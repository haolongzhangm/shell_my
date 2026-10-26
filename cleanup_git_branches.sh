#!/usr/bin/env bash
set -Eeuo pipefail

token=${GITLAB_TOKEN:-}
repo_url=
dry_run=false
remote_api_base=
project_path=
project_encoded=
tmp_dir=

usage() {
  cat <<'EOF'
Usage: cleanup_git_branches.sh [options] REPOSITORY_URL

Delete remote branches through the GitLab API, except:
  - master and main
  - the repository's default branch
  - branches whose names are also used by tags
  - source/target branches referenced by open merge requests
  - branches matched by the repository's protected-branch rules

The repository URL can be an HTTPS clone URL or an SSH clone URL, for example:
  https://git.jiigan.com/hpc01/hpc_server.git
  git@git.jiigan.com:hpc01/hpc_server.git

Options:
  -t, --token TOKEN  GitLab token with the api scope (read_api is not enough)
      --repo-url URL  Use URL instead of the positional repository argument
      --dry-run      Only show which branches would be deleted
  -h, --help         Show this help

The token can also be supplied via GITLAB_TOKEN. If neither is provided,
the script prompts for it without echoing the input.
All reads and deletes use this token; no local repository or SSH credentials
are used. Tags are never sent to a delete endpoint.
EOF
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

while (($#)); do
  case "$1" in
    -t|--token)
      (($# >= 2)) || die "Missing value for $1"
      token=$2
      shift 2
      ;;
    --repo-url)
      (($# >= 2)) || die "Missing value for $1"
      repo_url=$2
      shift 2
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      usage >&2
      die "Unknown option: $1"
      ;;
    *)
      [[ -z "$repo_url" ]] || die "Only one repository URL may be supplied"
      repo_url=$1
      shift
      ;;
  esac
done

[[ -n "$repo_url" ]] || {
  usage >&2
  die "A GitLab repository URL is required"
}

if [[ -z "$token" ]]; then
  if [[ ! -t 0 ]]; then
    die "No token provided; set GITLAB_TOKEN or run interactively"
  fi
  read -r -s -p 'GitLab token (requires the api scope): ' token
  printf '\n'
fi
[[ -n "$token" ]] || die "GitLab token must not be empty"
[[ "$token" != *$'\n'* && "$token" != *$'\r'* ]] ||
  die 'GitLab token must be a single line'

for command_name in curl jq; do
  command -v "$command_name" >/dev/null 2>&1 ||
    die "Required command not found: $command_name"
done

parse_repository_url() {
  local url=$1 host path

  case "$url" in
    https://*)
      [[ "$url" =~ ^(https://)([^/]+)(/.+)$ ]] ||
        die "Invalid HTTPS repository URL: $url"
      remote_api_base="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
      path=${BASH_REMATCH[3]}
      ;;
    http://*)
      die 'Plain HTTP repository URLs are not accepted because the API token would be sent without TLS; use HTTPS or SSH'
      ;;
    ssh://*)
      [[ "$url" =~ ^ssh://([^@/]+@)?([^/]+)(/.+)$ ]] ||
        die "Invalid SSH repository URL: $url"
      host=${BASH_REMATCH[2]}
      remote_api_base="https://$host"
      path=${BASH_REMATCH[3]}
      ;;
    *:*)
      [[ "$url" =~ ^([^:]+@)?([^:]+):(.+)$ ]] ||
        die "Invalid SSH repository URL: $url"
      host=${BASH_REMATCH[2]}
      remote_api_base="https://$host"
      path=/${BASH_REMATCH[3]}
      ;;
    *)
      die "Unsupported repository URL; use an HTTPS or SSH clone URL"
      ;;
  esac

  path=${path#/}
  path=${path%/}
  path=${path%.git}
  path=${path%/}
  [[ -n "$path" && "$path" != *'?'* && "$path" != *'#'* ]] ||
    die "Repository URL does not contain a valid project path"

  project_path=$path
  project_encoded=$(jq -nr --arg value "$project_path" '$value | @uri')
}

urlencode() {
  jq -nr --arg value "$1" '$value | @uri'
}

api_request() {
  local method=$1 endpoint=$2 output=$3 status

  if ! status=$(printf 'PRIVATE-TOKEN: %s\n' "$token" |
    curl --silent --show-error \
      --request "$method" \
      --header @- \
      --output "$output" \
      --write-out '%{http_code}' \
      "$remote_api_base/api/v4/$endpoint"); then
    die "GitLab API request failed: $method $endpoint"
  fi
  printf '%s' "$status"
}

api_error_message() {
  local body=$1
  jq -r 'if type == "object" then
           (.message // .error // .error_description // empty)
         else empty end' "$body" 2>/dev/null |
    tr '\n' ' ' |
    cut -c 1-300
}

expect_status() {
  local status=$1 expected=$2 method=$3 endpoint=$4 body=$5 message
  [[ "$status" == "$expected" ]] && return 0
  message=$(api_error_message "$body" || true)
  if [[ -n "$message" ]]; then
    die "GitLab API returned HTTP $status for $method $endpoint: $message"
  fi
  die "GitLab API returned HTTP $status for $method $endpoint"
}

fetch_paginated_names() {
  local endpoint=$1 output=$2 description=$3 page=1 count status body
  : > "$output"

  while :; do
    body="$tmp_dir/response-$description-$page.json"
    status=$(api_request GET \
      "$endpoint?per_page=100&page=$page" \
      "$body")
    expect_status "$status" 200 GET "$endpoint" "$body"
    jq -e 'type == "array"' "$body" >/dev/null ||
      die "Unexpected response while reading $description"
    jq -r '.[].name' "$body" >> "$output"
    count=$(jq 'length' "$body")
    ((count < 100)) && break
    page=$((page + 1))
  done

  LC_ALL=C sort -u -o "$output" "$output"
}

fetch_open_mr_branches() {
  local output=$1 page=1 count status body endpoint
  : > "$output"

  while :; do
    endpoint="projects/$project_encoded/merge_requests?state=opened&scope=all"
    body="$tmp_dir/response-merge-requests-$page.json"
    status=$(api_request GET "$endpoint&per_page=100&page=$page" "$body")
    expect_status "$status" 200 GET "$endpoint" "$body"
    jq -e 'type == "array"' "$body" >/dev/null ||
      die 'Unexpected response while reading open merge requests'
    jq -r '.[] |
      .target_branch,
      .source_branch' \
      "$body" >> "$output"
    count=$(jq 'length' "$body")
    ((count < 100)) && break
    page=$((page + 1))
  done

  LC_ALL=C sort -u -o "$output" "$output"
}

parse_repository_url "$repo_url"
tmp_dir=$(mktemp -d)
trap 'rm -rf -- "$tmp_dir"' EXIT

printf 'Validating GitLab token and project access...\n'
user_body="$tmp_dir/user.json"
status=$(api_request GET user "$user_body")
if [[ "$status" != 200 ]]; then
  message=$(api_error_message "$user_body" || true)
  [[ -n "$message" ]] || message='token is invalid, expired, or lacks the required API scope'
  die "Token validation failed (HTTP $status): $message"
fi
user_name=$(jq -r '.username // .name // "unknown user"' "$user_body")
user_is_admin=$(jq -r '.is_admin // false' "$user_body")

project_body="$tmp_dir/project.json"
status=$(api_request GET "projects/$project_encoded" "$project_body")
expect_status "$status" 200 GET "projects/$project_encoded" "$project_body"
project_id=$(jq -er '.id' "$project_body") || die 'GitLab project response has no numeric id'
default_branch=$(jq -r '.default_branch // empty' "$project_body")
project_access=$(jq -r '.permissions.project_access.access_level // 0' "$project_body")
group_access=$(jq -r '.permissions.group_access.access_level // 0' "$project_body")
has_permissions=$(jq -r '
  ((.permissions.project_access.access_level // null) != null or
   (.permissions.group_access.access_level // null) != null)' \
  "$project_body")

if [[ "$user_is_admin" != true ]]; then
  if [[ "$has_permissions" != true ]] ||
    ! [[ "$project_access" =~ ^[0-9]+$ && "$group_access" =~ ^[0-9]+$ ]]; then
    die "GitLab did not return project permissions for token user $user_name; refusing to delete branches"
  fi
  if ((project_access < 30 && group_access < 30)); then
    die "Token user $user_name has no Developer-level project access; branch deletion would be rejected"
  fi
fi

printf 'Authenticated as %s; project id %s.\n' "$user_name" "$project_id"
printf 'Reading branches, tags, open merge requests, and protected-branch rules...\n'

branches_file="$tmp_dir/branches"
tags_file="$tmp_dir/tags"
protected_file="$tmp_dir/protected-patterns"
mr_file="$tmp_dir/mr-branches"
fetch_paginated_names "projects/$project_encoded/repository/branches" \
  "$branches_file" branches
fetch_paginated_names "projects/$project_encoded/repository/tags" \
  "$tags_file" tags
fetch_paginated_names "projects/$project_encoded/protected_branches" \
  "$protected_file" protected-branches
fetch_open_mr_branches "$mr_file"

exact_keep_file="$tmp_dir/exact-keep"
{
  # HEAD is normally a symbolic ref, not a user branch. Keep it even if a
  # GitLab mirror/API exposes it in the branch list.
  printf '%s\n' HEAD master main
  [[ -n "$default_branch" ]] && printf '%s\n' "$default_branch"
  cat "$tags_file" "$mr_file"
} | sed '/^$/d' | LC_ALL=C sort -u > "$exact_keep_file"

keep_file="$tmp_dir/keep-branches"
delete_file="$tmp_dir/delete-branches"
: > "$keep_file"
: > "$delete_file"

is_exact_keep() {
  local branch=$1 candidate
  while IFS= read -r candidate; do
    [[ "$branch" == "$candidate" ]] && return 0
  done < "$exact_keep_file"
  return 1
}

is_protected() {
  local branch=$1 pattern
  while IFS= read -r pattern; do
    # GitLab protected-branch names use wildcard patterns; Bash's matching
    # rules cover the documented '*' form and also handle exact names.
    [[ "$branch" == $pattern ]] && return 0
  done < "$protected_file"
  return 1
}

while IFS= read -r branch; do
  if is_exact_keep "$branch" || is_protected "$branch"; then
    printf '%s\n' "$branch" >> "$keep_file"
  else
    printf '%s\n' "$branch" >> "$delete_file"
  fi
done < "$branches_file"

printf '\nAuthenticated user: %s\n' "$user_name"
printf 'Tags found: %s (tag refs are never deleted)\n' "$(wc -l < "$tags_file")"
printf 'Protected-branch rules found: %s\n' "$(wc -l < "$protected_file")"
printf '\nBranches to keep:\n'
if [[ -s "$keep_file" ]]; then
  LC_ALL=C sort -u "$keep_file" | sed 's/^/  /'
else
  printf '  (none)\n'
fi

printf '\nRemote branches marked for deletion:\n'
if [[ ! -s "$delete_file" ]]; then
  printf '  (none)\n'
  exit 0
fi
nl -ba "$delete_file"

if [[ "$dry_run" == true ]]; then
  printf '\nDry run: no branches or tags were deleted.\n'
  exit 0
fi

if [[ ! -t 0 ]]; then
  die 'Deletion requires an interactive terminal; use --dry-run to preview'
fi

read -r -p $'\nType DELETE to delete the listed branches through GitLab: ' confirmation
if [[ "$confirmation" != DELETE ]]; then
  printf 'Cancelled; no branches or tags were deleted.\n'
  exit 0
fi

failed=0
delete_index=0
while IFS= read -r branch; do
  branch_encoded=$(urlencode "$branch")
  endpoint="projects/$project_encoded/repository/branches/$branch_encoded"
  body="$tmp_dir/delete-$delete_index.json"
  delete_index=$((delete_index + 1))
  status=$(api_request DELETE "$endpoint" "$body")
  if [[ "$status" == 204 ]]; then
    printf 'Deleted branch: %s\n' "$branch"
  elif [[ "$status" == 401 || "$status" == 403 ]]; then
    message=$(api_error_message "$body" || true)
    [[ -n "$message" ]] || message='token is invalid, lacks the api scope, or cannot delete branches'
    die "GitLab rejected branch deletion for $branch (HTTP $status): $message"
  else
    message=$(api_error_message "$body" || true)
    if [[ -n "$message" ]]; then
      printf 'Failed to delete %s (HTTP %s): %s\n' "$branch" "$status" "$message" >&2
    else
      printf 'Failed to delete %s (HTTP %s)\n' "$branch" "$status" >&2
    fi
    failed=1
  fi
done < "$delete_file"

if ((failed)); then
  die 'Some branches could not be deleted; no tag deletion was attempted'
fi

printf 'Branch cleanup complete. Tags were not deleted.\n'
