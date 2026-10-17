{ lib, pkgs, themeName, sharedLib, ... }:

let
  dconf = sharedLib.dconf;
  themePackages = import ./packages.nix { inherit pkgs; };

  shellThemeName = themePackages.shellThemeName;
  catppuccinWallpaper = pkgs.nixos-artwork.wallpapers.nineish-catppuccin-mocha;
  wallpaperUri = "file://${catppuccinWallpaper}/share/backgrounds/nixos/nix-wallpaper-nineish-catppuccin-mocha.png";
in
{
  config = lib.mkIf (themeName == "catppuccin-mocha") {
    environment.sessionVariables = {
      GTK_THEME = shellThemeName;
      XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
    };

    environment.systemPackages = [
      (lib.hiPrio themePackages.catppuccinTheme)
      catppuccinWallpaper
      pkgs.catppuccin-cursors.mochaDark
      (lib.hiPrio themePackages.papirusIconTheme)
    ];

    programs.dconf.profiles.user.databases = (dconf.mkLockedDatabases {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = "catppuccin-mocha-dark-cursors";
        gtk-theme = shellThemeName;
        icon-theme = "Papirus-Dark";
      };

      "org/gnome/desktop/background" = {
        picture-options = "zoom";
      };

      "org/gnome/desktop/screensaver" = {
        picture-options = "zoom";
        picture-uri = wallpaperUri;
      };

      "org/gnome/shell/extensions/user-theme" = {
        name = shellThemeName;
      };
    }) ++ [ {
      settings."org/gnome/desktop/background" = {
        picture-uri = wallpaperUri;
        picture-uri-dark = wallpaperUri;
      };
    } ];
  };
}
