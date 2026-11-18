#! /bin/bash
set -euo pipefail

# directory of this script, so it works when run from anywhere
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load .env if it exists
if [[ -f "${DOTFILES}"/.env ]]; then
	set -a
	source "${DOTFILES}"/.env
	set +a
else
	echo ".env file not found. Copy .env.example to .env and fill it in"
fi
# login name (USER can be unset, e.g. in some containers)
USER="${USER:-$(id -un)}"
# name of this user's entry in flake.nix homeConfigurations
FLAKENAME="${FLAKENAME:-${USER}}"

# mkdir if doesn't exist
mkdir -p ~/.vim/after/syntax
# vim keeps words added with zg here (see spellfile in vimrc)
mkdir -p "${DOTFILES}"/spell
mkdir -p ~/.config/
mkdir -p ~/.config/fish/conf.d

# symlink $1 -> $2 without prompting; back up a real file that is in the way.
# Skips files that aren't in this repo (e.g. not part of a public copy).
link() {
	if [[ ! -e "$1" ]]; then
		echo "skipped $2: $1 not found"
		return
	fi
	if [[ -e "$2" && ! -L "$2" ]]; then
		mv "$2" "$2.bak"
		echo "backed up $2 to $2.bak"
	fi
	ln -sfn "$1" "$2"
}

# generate symbolic links
link "${DOTFILES}"/vimrc ~/.vimrc
link "${DOTFILES}"/vimwiki.vim ~/.vim/after/syntax/vimwiki.vim
link "${DOTFILES}"/bash_aliases ~/.bash_aliases
link "${DOTFILES}"/tmux.conf ~/.tmux.conf
link "${DOTFILES}"/markdownlint.json ~/.markdownlint.json

# symbolic links for fish shell
# config.fish is read from ~/.config/fish and every file in conf.d is sourced on startup
link "${DOTFILES}"/config.fish ~/.config/fish/config.fish
link "${DOTFILES}"/abbr.fish ~/.config/fish/conf.d/abbr.fish
link "${DOTFILES}"/functions.fish ~/.config/fish/conf.d/functions.fish

# git: shared settings are linked, name and email go to the untracked ~/.gitconfig.local
link "${DOTFILES}"/gitconfig ~/.gitconfig
if [[ -z "${GITNAME:-}" || -z "${EMAIL:-}" ]]; then
	echo "GITNAME=${GITNAME:-}"
	echo "EMAIL=${EMAIL:-}"
	echo "Please set GITNAME and EMAIL in .env for ~/.gitconfig.local"
else
	git config --file ~/.gitconfig.local user.name "$GITNAME"
	git config --file ~/.gitconfig.local user.email "$EMAIL"
fi

# home-manager reads ~/.config/home-manager/flake.nix, so point that dir at this repo
link "${DOTFILES}" ~/.config/home-manager

# add this user to homeConfigurations in flake.nix if missing
if [[ ! "${FLAKENAME}" =~ ^[A-Za-z_][A-Za-z0-9_-]*$ ]]; then
	echo "FLAKENAME '${FLAKENAME}' can only have letters, digits, _ and -, and can't start with a digit"
	exit 1
fi
if ! grep -qE "^[[:space:]]*${FLAKENAME}[[:space:]]*=[[:space:]]*mkHome" "${DOTFILES}"/flake.nix; then
	sed -i "/homeConfigurations = {/a\\        ${FLAKENAME} = mkHome \"${USER}\";" "${DOTFILES}"/flake.nix
	echo "added '${FLAKENAME} = mkHome \"${USER}\";' to flake.nix"
fi

# home-manager switch picks the entry named after the login name; any other name needs #FLAKENAME
flakeref="${DOTFILES}"
[[ "${FLAKENAME}" == "${USER}" ]] || flakeref="${DOTFILES}#${FLAKENAME}"
# --inputs-from: use the home-manager version pinned in flake.lock
# -b backup: rename files that are in home-manager's way to *.backup instead of failing
bootstrap=(nix --extra-experimental-features "nix-command flakes" run --inputs-from "${DOTFILES}"
	home-manager -- switch -b backup --flake "${flakeref}")
if command -v home-manager &>/dev/null; then
	echo "home-manager is already installed, run 'home-manager switch --flake ${flakeref}' to apply home.nix"
elif ! command -v nix &>/dev/null; then
	echo "Nix not found: install it (see README.md), then rerun ./install.sh"
else
	answer=n
	if [[ -t 0 ]]; then
		read -r -p "home-manager not found. Install it and apply home.nix now (downloads all the packages)? [Y/n] " answer
		answer="${answer:-y}"
	fi
	if [[ "${answer}" == [Yy]* ]]; then
		"${bootstrap[@]}"
	else
		echo "home-manager not installed. To install it and apply home.nix, run:"
		# %q keeps the quoting, so the printed command can be pasted as is
		printf '  '
		printf '%q ' "${bootstrap[@]}"
		echo
	fi
fi

# fish files can't be sourced from bash
if [[ "$SHELL" == *"fish"* ]]; then
	echo "Restart fish (or run 'exec fish') to load the new config"
else
	echo "Please switch to fish shell to use the fish config"
fi
