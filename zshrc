# LOAD ZSH COMPONENTS ----------------------------------------------------------
autoload -U compinit promptinit colors
compinit
promptinit
colors

# arrow key driven autocomplete interface
zstyle ':completion:*' menu select

# PROMPT -----------------------------------------------------------------------
# builtin style
# for list of prompts, run `prompt -l`
# `prompt` requires `autoload -U promptinit && promptinit`
#prompt walters

# git status
# wiki.archlinux.org/index.php/Git#Git_Prompt
setopt PROMPT_SUBST     # set zsh to evaluate functions/substitutions in prompt PS1
source ~/.git-prompt.sh

# wiki.archlinux.org/index.php/Zsh#Colors
PROMPT='%n@%{$fg[green]%}%m%{$reset_color%} %1d%{$fg[cyan]%}$(__git_ps1 " [%s]")%{$reset_color%} %# '
RPROMPT='%{$fg[green]%}[%?] %d%{$reset_color%}' 

# KEY BINDINGS -----------------------------------------------------------------
# key bindings style
# bindkey -v  # -v for vim, -e for emacs
bindkey -e

# fix broken backspace key on some keyboards
# stty erase ^H

# get special keys working (home, end, delete)
# https://wiki.archlinux.org/index.php/Zsh#Key_bindings
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
	function zle-line-init () {
		printf '%s' "${terminfo[smkx]}"
	}
	function zle-line-finish () {
		printf '%s' "${terminfo[rmkx]}"
	}
	zle -N zle-line-init
	zle -N zle-line-finish
fi


# ENVIRONMENT ------------------------------------------------------------------
typeset -U path
#path=(/usr/local/heroku/bin $path) # heroku toolbelt
path=($HOME/adt/sdk/platform-tools $path)
path=($HOME/bin $path)
path=($HOME/.gem/ruby/2.1.0/bin $path)
path=($HOME/code/go/bin $path)
path=(/usr/local/bin $path)

. $HOME/.shexports
. $HOME/.shaliases

# MISC -------------------------------------------------------------------------
# colored manpage w/ less
man() {
	env LESS_TERMCAP_mb=$'\E[01;31m' \
	LESS_TERMCAP_md=$'\E[01;38;5;74m' \
	LESS_TERMCAP_me=$'\E[0m' \
	LESS_TERMCAP_se=$'\E[0m' \
	LESS_TERMCAP_so=$'\E[38;5;246m' \
	LESS_TERMCAP_ue=$'\E[0m' \
	LESS_TERMCAP_us=$'\E[04;38;5;146m' \
	man "$@"
}