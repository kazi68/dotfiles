# up
	function up_widget() {
		BUFFER="cd .."
		zle accept-line
	}
	zle -N up_widget
	bindkey "^k" up_widget

# git
	function git_prepare() {
		if [ -n "$BUFFER" ];
			then
				BUFFER="git add -A; git commit -S -m \"$BUFFER\" && git push"
		fi

		if [ -z "$BUFFER" ];
			then
				BUFFER="git add -A; git commit -S -v && git push"
		fi
				
		zle accept-line
	}
	zle -N git_prepare
	bindkey "^g" git_prepare

# home
	function goto_home() { 
		BUFFER="cd ~/"$BUFFER
		zle end-of-line
		zle accept-line
	}
	zle -N goto_home
	bindkey "^h" goto_home

# Edit and rerun
	function edit_and_run() {
		BUFFER="fc"
		zle accept-line
	}
	zle -N edit_and_run
	bindkey "^v" edit_and_run

# LS
	function ctrl_l() {
		BUFFER="ls"
		zle accept-line
	}
	zle -N ctrl_l
	bindkey "^l" ctrl_l

# Clear
	function ctrl_x() {
		BUFFER="clear"
		zle accept-line
	}
	zle -N ctrl_x
	bindkey "^x" ctrl_x

# Delete a word or a slash backwards
	function delword() {
		local WORDCHARS=${WORDCHARS/\/}
		zle backward-kill-word
	}
	zle -N delword
	bindkey "^[^?" delword #Alt backspace

# Delete a word or a slash forwards
	function delword_forward() {
		local WORDCHARS=${WORDCHARS/\/}
		zle kill-word
	}
	zle -N delword_forward
	bindkey "3~" delword_forward #Alt del

# Exit - not built-in for WSL
	function ctrl_d() {
		BUFFER="exit"
		zle accept-line
	}
	zle -N ctrl_d
	bindkey "^d" ctrl_d

# Enter
	function enter_line() {
		zle accept-line
	}
	zle -N enter_line
	bindkey "^o" enter_line

# Sudo
	function add_sudo() {
		BUFFER="sudo "$BUFFER
		zle end-of-line
	}
	zle -N add_sudo
	bindkey "^s" add_sudo
