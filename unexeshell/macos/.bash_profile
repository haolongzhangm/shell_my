 [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Tell ls to be colourful
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'

export TERM="xterm-color"
PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '
################################################################################################################
export PATH=~/shell_my:$PATH
export PATH=~/android_tool/platform-tools:$PATH
alias gitlog='git log --pretty=format:'\''%h : %an : %ad : %s'\'' --topo-order --graph --date=short'
alias v=vim
alias V=vim
alias gvim='LANG=EN gvim'
alias mysource=source
alias cdf='cd $(find . -type d| pick)'
source ~/.git-completion.bash
#enable and config ccache
#use command config: ./prebuilts/misc/linux-x86/ccache/ccache -M 50G
#also command config: ccache -M 50G
#use command to check status: ccache -s
#export USE_CCACHE=1
#export CCACHE_DIR=/media/zhl/second/.cache
function cdl {
	builtin cd "$@" && ls --color && find . -maxdepth 1 -type d
}

function cdn {
if [ $# -gt 1 ]
then
	echo "need only one parm"
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
	back_to="./"
for loop_i in $(seq 1 $1)
do
	echo $loop_i
	back_to=${back_to}"../"
done
	echo ${back_to}
	builtin cd ${back_to} && ls --color
else
	echo "PWD: $PWD"
	if [ $# -eq 0 ]
	then
		echo "Usage:"
		echo "      cdn [num]: back to num"
		echo "      cdn ["dir"] : back to "dir""
		echo "      eg: when you at dir:"
		echo "      /home/zhl/mycode/linux_kernel_learn/drivers/cpufreq"
		echo "      you can use below command to 'mycode' dir qucikly"
		echo "      :cdn mycode or . cdn 3"
	else
		echo "TODIR: $1"
		Index=`awk 'BEGIN{print match("'$PWD'","'$1'")}'`
		echo "Index: $Index"
		if [[ $Index = 0 ]]
		then
			echo "ERR: can not find $1 from $PWD"
		fi
		tmp=$PWD
		new_dir="${tmp:0:$Index-1}""$1"
		echo "Now go to dir: $new_dir"
		cd $new_dir
	fi
fi

}
alias codedir='cd $(find ~/mycode/ -maxdepth 1 -type d| pick)'
alias dirsquick='cd $(dirs -l -v| pick | cut -c 3-)'
function h {
	`history | pick | cut -c 8-`
}
function desk {
	builtin cd ~/Desktop
}

function desk_tmp_file {
	desk
	builtin cd tmp_file
}

#macos special
alias ll='ls -alF'
alias la='ls -A'
#install from brew install findutils
alias l='ls -CF'
export PATH=/usr/local/opt/findutils/libexec/gnubin:$PATH
export PATH=/Users/zhl/mycode/ndk/android-ndk-r19c_standalone_arm64/bin:$PATH
export PATH=/Users/zhl/mycode/ndk/android-ndk-r19c_standalone_arm/bin:$PATH
