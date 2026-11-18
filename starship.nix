{ config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      palettes = {
        gruvbox_dark = {
          color_fg0 = "#fbf1c7";
          color_bg1 = "#3c3836";
          color_bg3 = "#665c54";
          color_blue = "#458588";
          color_aqua = "#689d6a";
          color_green = "#98971a";
          color_orange = "#d65d0e";
          color_purple = "#b16286";
          color_red = "#cc241d";
          color_yellow = "#d79921";
        };
      };
      shell = {
        # fish_indicator = "󰈺 ";
        fish_indicator = "fish";
        powershell_indicator = "_";
        unknown_indicator = "mystery shell";
        style = "cyan bold";
        disabled = false;
      };
      battery = {
        full_symbol = "🔋 ";
        charging_symbol = "⚡️ ";
        discharging_symbol = "💀 ";
      };
      username = {
        show_always = true;
        format = "[╭─$user]($style)@";
        style_user = "bold bg:#b16286 fg:#3c3836";
        style_root = "bg:#9A348E";
      };
      hostname = {
        ssh_only = false;
        format = "[$ssh_symbol$hostname]($style) in ";
        style = "bold fg:#3c3836 bg:#b16286";
      };
      directory = {
        truncation_length = 0;
        truncate_to_repo = false;
        format = "[$path]($style) ";
        style = "bold cyan";
      };
      git_branch = {
        format = "[🌱 $branch]($style) ";
        style = "bold yellow";
      };
      git_commit = {
        commit_hash_length = 7;
        tag_symbol = "🔖 ";
      };
      git_status = {
        untracked = "";
        staged = "+";
        modified = "~";
        conflicted = "!";
        style = "bold green";
      };
      cmd_duration = {
        min_time = 0;
        show_milliseconds = true;
        format = " [$duration]($style)";
        style = "bold white";
      };
      python = {
        format = "[$symbol$version $virtualenv]($style) ";
        style = "fg:#d65d0e bg:#3c3836";
      };
      direnv = {
        disabled = false;
        symbol = "🌀 ";
        format = "[$symbol$dirname]($style) ";
        style = "bold blue";
      };
      gcloud = {
        disabled = true;
        format = "[$symbol$account]($style) ";
        style = "fg:#4285f4 bg:#3c3836";
      };
    };
  };
}
