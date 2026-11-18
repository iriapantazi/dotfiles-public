{ pkgs, ... }:

let
  # to fetch the sha:
  # nix-prefetch-url --unpack  https://github.com/NixOS/nixfmt/archive/refs/tags/v1.0.0.tar.gz
  nixfmt_1_0_0 = pkgs.callPackage (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixfmt";
    rev = "v1.0.0";
    sha256 = "0iy2p893b2b5y4mvhy0d62675a7nd8fc6jm9mr32v9h2baj9ii3p";
  }) { };
  # installed by nix, not pip
  # nix python can't see Ubuntu's /usr/lib, so pip/uv wheels with compiled code (numpy,
  # torch, ...) need libstdc++ and zlib from nix. LD_LIBRARY_PATH is set only for python
  # (and venvs made from it): set globally it breaks Ubuntu's own C++ programs.
  python =
    (pkgs.python311.withPackages (
      ps: with ps; [
        numpy
        requests
        beartype
      ]
    )).override
      {
        makeWrapperArgs = [
          "--prefix"
          "LD_LIBRARY_PATH"
          ":"
          (pkgs.lib.makeLibraryPath [
            pkgs.stdenv.cc.cc.lib
            pkgs.zlib
          ])
        ];
      };
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  # home.username and home.homeDirectory are set per user in flake.nix
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    vim-full
    # copilot-cli
    # gemini-cli
    alsa-utils
    bash-language-server
    bat
    btop
    # cargo
    dust
    difftastic
    eza
    git
    gh
    # secret scan in publish.sh
    gitleaks
    go
    fd
    fish
    fzf
    horcrux
    htop
    yq
    just
    jq
    lazygit
    lazydocker
    markdownlint-cli2
    markdown-link-check
    mosh
    ncdu
    nodejs
    neovim
    nil
    obs-studio
    pyright
    pre-commit
    ripgrep
    ruff
    rustup
    shellcheck
    shfmt
    silver-searcher
    sox
    tmux
    traceroute
    tree
    uv
    vlc
    xclip
    # spell checker used by ALE in vim
    codespell
    # nix linters/formatters
    statix
    deadnix
    nixfmt_1_0_0
    gcc
    python
  ];

  # Packages that are installed by their programs.* below
  # bash isn't managed by home-manager (it would overwrite .bashrc and .profile),
  # so starship and zoxide are hooked into bash by hand in bash_aliases
  imports = [
    ./starship.nix
  ];
  # fish is handled by the ln -s in the install.sh and conflicts with nix-handled config.fish
  programs.zoxide.enable = true;

  programs.zk.enable = true;
  # Modify `${XDG_CONFIG_HOME}/zk/config.toml` through this attr
  programs.zk.settings = {
    # Add your own configuration settings for zk here
  };
}
