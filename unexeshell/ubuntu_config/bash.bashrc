# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ] && [ ! -e "$HOME/.hushlogin" ] ; then
    case " $(groups) " in *\ admin\ *)
    if [ -x /usr/bin/sudo ]; then
	cat <<-EOF
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.
	
	EOF
    fi
    esac
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
		   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
		else
		   printf "%s: command not found\n" "$1" >&2
		   return 127
		fi
	}
fi
#add for java hoome
##now close export java env at here, redefine java env by command: . sun_java_env
#export JAVA_HOME=/home/zhl/java_home/jdk1.6.0_26
#export PATH=$JAVA_HOME/bin:$PATH
#export CLASSPATH=$CLASSPATH:$JAVA_HOME/lib
#add for my shell env no use
#export PATH=/home/zhl/notepad/Notepad++:$PATH
export PATH=/home/zhl/shell_my:$PATH
export PATH=/media/zhl/second/old_home_dir/ARM_Compiler_5/bin:$PATH
export ARMBIN=/media/zhl/second/old_home_dir/ARM_Compiler_5/bin64
export ARMLIB=/media/zhl/second/old_home_dir/ARM_Compiler_5/lib
export ARMINC=/media/zhl/second/old_home_dir/include
#add for hicam build shell compelte
complete -W "n_pr n_kernel n_bootimage n_recovery n_lk n_all r_pr r_kernel r_bootimage r_recovery r_lk r_all" hicam
complete -W "n_pr n_kernel n_bootimage n_recovery n_lk n_all r_pr r_kernel r_bootimage r_recovery r_lk r_all" xs
complete -W "n_pr n_kernel n_bootimage n_recovery n_lk n_all r_pr r_kernel r_bootimage r_recovery r_lk r_all" 2hicam
complete -W "3qcom 2qcom qcom 8976_1_qcom 2hicam 8976_2_qcom" mysource
#add for qcom modem build tool env
export HEXAGON_ROOT=/home/zhl/Qualcomm/HEXAGON_Tools
export HEXAGON_RTOS_RELEASE=6.4.01
export ARMTOOLS=QDSP6GCC
#add for other shell command compelte
complete -W "normal_proj_tags_update mtk_kk_old_kernel_tags_update kernel_arm32_cscope kernel_arm64_cscope" other_shell
alias gitlog='git log --pretty=format:'\''%h : %an : %ad : %s'\'' --topo-order --graph --date=short'
alias v=vim
alias V=vim
alias mysource==source
