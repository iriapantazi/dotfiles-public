#! /bin/bash
#
# don't let Ctrl-S freeze the terminal (XOFF flow control); Ctrl-Q would unfreeze it
[[ $- == *i* ]] && stty -ixon
alias cl="clear"
alias cp="cp -iv"
alias df="df -h"
alias dif="difft"
alias du="du -h"
alias greppy="grep -nrI --include=\*.py"
alias grepmd="grep -nrI --include=\*.md"
alias grepjs="grep -nrI --include=\*.js"
alias e="eza -l"
alias er="eza -l --sort=accessed" # can be modified, accessed, created
alias ed="eza -ld */"
# alias f="find . -type f -name "
alias h="history"
alias j="jobs -l"
#
alias l='ls -l'
alias ll='ls -la'
alias lr="ls -ltr"
alias lsd="ls -ld */"
alias ldr="ls -ldr */"
#
alias lazy="lazygit"
#
alias mkdir="mkdir -pv"
alias mv="mv -iv"
alias rm="rm -iv"
alias rp="realpath -s"
#
alias tmux="tmux -2"
alias ta="tmux attach-session -t"
alias tl="tmux ls"
alias tn="tmux new -s"
alias tkill="tmux kill-session -t"
#
alias v="vim"
alias vim="vim -p"
alias wl="wc -l"
alias wh="which"

# nix & home-manager
# search a nixpkgs plugin set (available, not installed), e.g. nixplugins vim fzf
# the first arg picks the set (vim -> vimPlugins, tmux -> tmuxPlugins); with no term it lists all
nixplugins() {
	# ^ matches everything: nix search refuses to run without a term
	if (($# > 1)); then nix search "nixpkgs#${1}Plugins" "${@:2}"; else nix search "nixpkgs#${1}Plugins" ^; fi
}
alias hmb="home-manager build"
alias hms="home-manager switch"

# my aliases
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias diff="diff --color" # side-by-side with sidediff; -y here would break patches
alias cpv='rsync -ah --info=progress2' # copy with progress bar

## functions
# sidediff
sidediff() {
	diff --color -y <(fold -s -w ${3:-20} $1) <(fold -s -w ${3:-20} $2)
}
# diff of what the last N pushes changed (default 1), using the branch's upstream
# reflog; extra args go to git diff, e.g. lastpush 2 --stat
lastpush() {
	local up
	up=$(git rev-parse --abbrev-ref '@{u}') || return
	git diff "$up@{${1:-1}}" "$up" "${@:2}"
}
# fuzzy-find a file and open it in $EDITOR (vim if unset)
fp() {
	local file
	file=$(fzf --preview 'cat {}') || return
	"${EDITOR:-vim}" "$file"
}
# find by name suffix
findbyname() {
	find . -type f -name "*.$1"
}
# watch nvidia-smi
nv() {
	watch -n ${1:-1} nvidia-smi
}
# ps aux
psa() {
	ps aux | grep $1
}
# docker
dockersudo() {
	sudo usermod -aG docker $USER && newgrp docker
}

# prompt and smarter cd (installed by home-manager); skipped if not installed yet
command -v starship &>/dev/null && eval "$(starship init bash)"
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"

# fzf lists files with fd: skips .gitignored files and doesn't follow nix build's
# result symlinks into /nix/store (fzf's own walker follows symlinks)
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
