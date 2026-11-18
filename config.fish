
# fzf lists files with fd: skips .gitignored files and doesn't follow nix build's
# result symlinks into /nix/store (fzf's own walker follows symlinks)
set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --exclude .git"

if status is-interactive
  # don't let Ctrl-S freeze the terminal (XOFF flow control); Ctrl-Q would unfreeze it
  stty -ixon
  # start starship in fish
  command -q starship; and starship init fish | source

  # aliases are abbreviations
  # they are under ~/.config/fish/conf.d/abbr.fish

  # start zoxide in fish
  command -q zoxide; and zoxide init fish | source
end
