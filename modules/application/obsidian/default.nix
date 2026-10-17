{ config, lib, pkgs, targetUser, ... }:

let
  cfg = config.application.obsidian;
  styleSettings = import ./style-settings.nix { inherit pkgs; };
  themeRevision = "7ebbd577464d6ef8a18cb02811983bee623f30d6";
  themeCss = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/obsidian/${themeRevision}/theme.css";
    hash = "sha256-bBMwcArgB39cedlQqQF5pC53eHIp3hJ25cvloEjlcu0=";
  };
  themeManifest = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/obsidian/${themeRevision}/manifest.json";
    hash = "sha256-tjVkGOZ7922GJApDRi5kE7eq/j5x8/7ljoVEJR7iVxI=";
  };
  theme = pkgs.runCommand "obsidian-catppuccin" {
    passthru.manifestId = "Catppuccin";
  } ''
    mkdir -p "$out"
    ln -s ${themeCss} "$out/theme.css"
    ln -s ${themeManifest} "$out/manifest.json"
  '';
in
{
  options.application.obsidian.vaultPath = lib.mkOption {
    type = lib.types.str;
    default = "Documents/Obsidian";
    description = "Path to the Obsidian vault relative to the user's home directory.";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.vaultPath != ""
          && !(lib.hasPrefix "/" cfg.vaultPath)
          && builtins.all (part: part != ".." && part != "." && part != "")
            (lib.splitString "/" cfg.vaultPath);
        message = "application.obsidian.vaultPath must be a non-empty path relative to the home directory without dot components.";
      }
    ];

    home-manager.users.${targetUser} = {
      programs.obsidian = {
        enable = true;
        vaults.personal = {
          target = cfg.vaultPath;
          settings = {
            appearance.theme = "obsidian";
            themes = [ theme ];
            communityPlugins = [
              {
                pkg = styleSettings;
                settings = {
                  "catppuccin-theme-settings@@catppuccin-theme-dark" = "ctp-mocha";
                  "catppuccin-theme-settings@@catppuccin-theme-accents" = "ctp-accent-mauve";
                };
              }
            ];
          };
        };
      };
    };
  };
}
