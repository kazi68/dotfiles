# Reference for colors: http://stackoverflow.com/questions/689765/how-can-i-change-the-color-of-my-prompt-in-zsh-different-from-normal-text

autoload -U colors && colors

setopt PROMPT_SUBST

# determine the window title escape sequences: https://unix.stackexchange.com/questions/7380/force-title-on-gnu-screen
case "$TERM" in
aixterm|dtterm|putty|rxvt|xterm*)
	titlestart='\033]0;'
	titlefinish='\007'
    ;;
cygwin)
    titlestart='\033];'
    titlefinish='\007'
    ;;
konsole)
    titlestart='\033]30;'
    titlefinish='\007'
    ;;
screen*)
    # status line
    #titlestart='\033_'
    #titlefinish='\033\'
    # window title
    titlestart='\033k'
    titlefinish='\033\'
    ;;
*)
    if type tput >/dev/null 2>&1
    then
        if tput longname >/dev/null 2>&1
        then
            titlestart="$(tput tsl)"
            titlefinish="$(tput fsl)"
        fi
    else
        titlestart=''
        titlefinish=''
    fi
    ;;
esac

# set the xterm/screen/etc. title
settitle()
{
	test -z "${titlestart}" && return 0
	printf "${titlestart}$*${titlefinish}"
}

TITLE=""
if [ "$SSH_CLIENT" != "" ]; then # Add a useful prefix if in an ssh session
	TITLE+="SSH: "
fi
TITLE+="${USER}@${HOST}" # Initial title
export TITLE


set_prompt() {

	# [
	PS1="%{$fg[white]%}[%{$reset_color%}"

	# Path: http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
	PS1+="%{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}"

	# Status Code
	PS1+='%(?.., %{$fg[red]%}%?%{$reset_color%})'

	# Git
	if git rev-parse --is-inside-work-tree 2> /dev/null | grep -q 'true' ; then
		PS1+=', '
		PS1+="%{$fg[blue]%}$(git rev-parse --abbrev-ref HEAD 2> /dev/null)%{$reset_color%}"
		if [ $(git status --short | wc -l) -gt 0 ]; then 
			PS1+="%{$fg[red]%}+$(git status --short | wc -l | awk '{$1=$1};1')%{$reset_color%}"
		fi
	fi


	# Timer: http://stackoverflow.com/questions/2704635/is-there-a-way-to-find-the-running-time-of-the-last-executed-command-in-the-shel
	if [[ $_elapsed[-1] -ne 0 ]]; then
		PS1+=', '
		PS1+="%{$fg[magenta]%}$_elapsed[-1]s%{$reset_color%}"
	fi

	# PID
	if [[ $! -ne 0 ]]; then
		PS1+=', '
		PS1+="%{$fg[yellow]%}PID:$!%{$reset_color%}"
	fi

	# Sudo: https://superuser.com/questions/195781/sudo-is-there-a-command-to-check-if-i-have-sudo-and-or-how-much-time-is-left
	CAN_I_RUN_SUDO=$(sudo -n uptime 2>&1|grep "load"|wc -l)
	if [ ${CAN_I_RUN_SUDO} -gt 0 ]
	then
		PS1+=', '
		PS1+="%{$fg_bold[red]%}PRIV%{$reset_color%}"
	fi

	PS1+="%{$fg[white]%}]"
	PS1+='
'
	PS1+=": %{$reset_color%}% "

	settitle "$TITLE"
}

precmd_functions+=set_prompt

preexec () {
   (( ${#_elapsed[@]} > 1000 )) && _elapsed=(${_elapsed[@]: -1000})
   _start=$SECONDS

   settitle "$TITLE: $1"
}

precmd () {
   (( _start >= 0 )) && _elapsed+=($(( SECONDS-_start )))
   _start=-1 
}
