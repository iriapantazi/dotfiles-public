# dotfiles

Dotfiles for vim, tmux, fish, bash and git, with packages managed by Nix and
home-manager (flake). Works on any Linux distribution with Nix; NixOS isn't needed.

## install

### 1. Nix

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Enable flakes in `~/.config/nix/nix.conf` (or `/etc/nix/nix.conf`):

```text
experimental-features = nix-command flakes
```

Open a new shell so `~/.nix-profile/bin` is on the `PATH`.

### 2. dotfiles

```bash
git clone <this repo> ~/repos/dotfiles
cd ~/repos/dotfiles
```

Copy `.env.example` to `.env` (not tracked by git) and fill it in:

```bash
GITNAME=<gitname>
EMAIL=<full email address>
# optional, default: your login name
FLAKENAME=<name>
```

and run:

```bash
./install.sh
```

This links the dotfiles, writes the git name and email to `~/.gitconfig.local`,
points `~/.config/home-manager` at this repo and adds you to `homeConfigurations` in
`flake.nix` (as `FLAKENAME`). Rerun it after editing `.env`.

### 3. packages (home-manager)

If you set a `FLAKENAME` different from your login name, add `#<FLAKENAME>` after
the flake path in the commands below.

If home-manager isn't installed yet, `install.sh` offers to install it (the version
pinned in `flake.lock`) and apply `home.nix`. Files that are in the way are renamed
to `*.backup`. To do it by hand:

```bash
nix run --inputs-from ~/repos/dotfiles home-manager -- switch -b backup --flake ~/repos/dotfiles
```

Afterwards, to apply changes to `home.nix`:

```bash
home-manager switch
```

New files must be `git add`ed before Nix can see them. `flake.lock` pins the exact
nixpkgs and home-manager versions, so every machine gets the same packages.

### 4. fish (optional)

```bash
echo "$(command -v fish)" | sudo tee -a /etc/shells
chsh -s "$(command -v fish)"
```

## Tools

```bash
  ┌──────────┬───────────────────────────┬───────────────────┬──────────────────────────┐
  │  Files   │ Language server (vim-lsp) │   Linters (ALE)   │   Fixers on save (ALE)   │
  ├──────────┼───────────────────────────┼───────────────────┼──────────────────────────┤
  │ python   │ pyright, ruff             │ codespell         │ ruff, ruff format        │
  ├──────────┼───────────────────────────┼───────────────────┼──────────────────────────┤
  │ markdown │ none                      │ markdownlint-cli2 │ trailing whitespace only │
  ├──────────┼───────────────────────────┼───────────────────┼──────────────────────────┤
  │ text     │ none                      │ codespell         │ trailing whitespace only │
  ├──────────┼───────────────────────────┼───────────────────┼──────────────────────────┤
  │ nix      │ nil                       │ statix, deadnix   │ nixfmt (1.0.0)           │
  ├──────────┼───────────────────────────┼───────────────────┼──────────────────────────┤
  │ sh       │ bash-language-server      │ shellcheck        │ shfmt                    │
  └──────────┴───────────────────────────┴───────────────────┴──────────────────────────┘
```

### 5. keyboard remapping (optional)

`keyd.conf` turns Caps Lock into Escape when tapped and Control when held, and Right Alt into Insert. It works
system-wide (X, Wayland, console) and only matters on the machine the keyboard is plugged into, not over ssh.

keyd isn't in Ubuntu 22.04's apt, so build it once per machine:

```bash
git clone https://github.com/rvaiya/keyd && cd keyd
make && sudo make install
sudo systemctl enable --now keyd
```

Then install the config (copied, not linked, since keyd runs as root):

```bash
sudo cp ~/repos/dotfiles/keyd.conf /etc/keyd/default.conf
sudo keyd reload
```

If GNOME also remaps Caps Lock (Tweaks → Keyboard → Additional Layout Options, e.g. `caps:swapescape`), turn that
off so the two don't conflict. To undo, remove `/etc/keyd/default.conf` and run `sudo keyd reload`.
