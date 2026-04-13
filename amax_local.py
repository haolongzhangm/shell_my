#!/usr/bin/env python3
"""SSH connection manager - replacement for amax_local scripts."""

import argparse
import subprocess
import sys

# Host name to IP mapping
HOST_MAP = {
    "engine": "10.235.81.101",
    "bj_hpc": "10.172.198.205",
    "cd_hpc": "10.235.80.15",
    "local": "localhost",
    "cd_hpc2": "10.235.80.220",
}

# Hosts that use port 2222
PORT_2222_HOSTS = {"localhost"}


def resolve_host(host_str):
    """Resolve host alias to IP address."""
    return HOST_MAP.get(host_str, host_str)


def build_ssh_command(args):
    """Build SSH command based on arguments."""
    cmd = ["ssh"]

    # Port
    if args.port:
        cmd.extend(["-p", str(args.port)])
    elif args.host_resolved in PORT_2222_HOSTS:
        cmd.extend(["-p", "2222"])

    # X11 forwarding
    if args.x11:
        cmd.append("-X")

    # Server alive interval (always set, like original scripts)
    cmd.extend(["-o", f"ServerAliveInterval {args.alive_interval}"])

    # Destination
    if args.user and args.host_resolved:
        cmd.append(f"{args.user}@{args.host_resolved}")
    elif args.host_resolved:
        cmd.append(args.host_resolved)
    else:
        print("Error: --host is required", file=sys.stderr)
        sys.exit(1)

    return cmd


def main():
    parser = argparse.ArgumentParser(
        description="SSH connection manager (replacement for amax_local scripts)"
    )

    # Connection target
    parser.add_argument("host", nargs="?", help="Target host (IP or alias: engine, bj_hpc, cd_hpc, local, cd_hpc2)")
    parser.add_argument("--user", "-u", default="zhl", help="Username (default: zhl)")
    parser.add_argument("--port", "-p", type=int, help="SSH port (default: 22, or 2222 for localhost)")

    # Features
    parser.add_argument("--x11", "-X", action="store_true", help="Enable X11 forwarding")

    # Advanced
    parser.add_argument(
        "--alive-interval",
        type=int,
        default=60,
        help="ServerAliveInterval in seconds (default: 60)",
    )
    parser.add_argument("--dry-run", action="store_true", help="Print command without executing")

    args = parser.parse_args()

    # Resolve host alias to IP
    if not args.host:
        print("Error: host is required", file=sys.stderr)
        print(f"Available aliases: {', '.join(HOST_MAP.keys())}", file=sys.stderr)
        sys.exit(1)

    args.host_resolved = resolve_host(args.host)

    # Build command
    cmd = build_ssh_command(args)

    if args.dry_run:
        print(" ".join(cmd))
        sys.exit(0)

    # Execute
    subprocess.run(cmd)


if __name__ == "__main__":
    main()
