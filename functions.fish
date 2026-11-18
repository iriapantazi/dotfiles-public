# all fish functions, sourced on startup from ~/.config/fish/conf.d

# fuzzy-find a file and open it in $EDITOR
function fp
  set -l file (fzf --preview 'cat {}'); or return
  set -l editor vim
  set -q EDITOR[1]; and set editor $EDITOR
  $editor $file
end

# grep recursively in python files
function greppy --wraps=grep --description 'grep -nrI --include=*.py'
  grep -nrI --include=\*.py $argv
end

# side-by-side diff of two files, wrapping lines at width (default 20)
function sidediff --argument-names a b width
  set -q width[1]; or set width 20
  diff --color -y (fold -s -w $width $a | psub) (fold -s -w $width $b | psub)
end

# diff of what the last n pushes changed (default 1), using the branch's upstream
# reflog; extra args go to git diff, e.g. lastpush 2 --stat
function lastpush --argument-names n --description 'git diff of the last n pushes'
  set -q n[1]; or set n 1
  set -l up (git rev-parse --abbrev-ref '@{u}'); or return
  git diff "$up@{$n}" $up $argv[2..]
end

# watch nvidia-smi every n seconds (default 1)
function nv --argument-names n --description 'watch nvidia-smi every n seconds'
  set -q n[1]; or set n 1
  watch -n $n nvidia-smi
end

# search a nixpkgs plugin set (available, not installed), e.g. nixplugins vim fzf
# the first arg picks the set (vim -> vimPlugins, tmux -> tmuxPlugins); with no term it lists all
function nixplugins --argument-names kind --description 'search a nixpkgs plugin set'
  # "$kind"Plugins, not "$kindPlugins", which would be a different variable
  set -l attr "nixpkgs#$kind"Plugins
  # ^ matches everything: nix search refuses to run without a term
  if set -q argv[2]
    nix search $attr $argv[2..]
  else
    nix search $attr '^'
  end
end
