{ lib, pkgs, sharedLib, ... }:

let
  dconf = sharedLib.dconf;
  extensionPackages = import ./packages.nix { inherit lib pkgs; };
in
{
  imports = [
    ./blur-my-shell.nix
    ./dash-to-dock.nix
    ./wallpaper.nix
  ];

  environment.systemPackages = extensionPackages.extensionPackages;

  networking.firewall.allowedTCPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];

  services.desktopManager.gnome.extraGSettingsOverridePackages = [
    extensionPackages.schemaPackage
  ];

  programs.dconf.profiles.user.databases = dconf.mkLockedDatabases {
    "org/gnome/shell/extensions/advanced-media-controller" = {
      panel-position = "left";
      panel-index = lib.gvariant.mkInt32 4;
    };

    "org/gnome/shell/extensions/top-bar-organizer" = {
      left-box-order = [
        "activities"
        "WorkspaceMenu"
        "FocusButton"
        "OpenPositionButton"
        "media-controls-advanced-media-controller@sanjai.com"
      ];
      right-box-order = [
        "appindicator-kstatusnotifieritem-flameshot"
        "gpaste"
        "keyboard"
        "quickSettings"
      ];
    };

    "org/gnome/shell/extensions/appindicator" = {
      compact-mode-enabled = false;
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "blur-my-shell@aunetx"
        "paperwm@paperwm.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "dash-to-dock@micxgx.gmail.com"
        "GPaste@gnome-shell-extensions.gnome.org"
        "gsconnect@andyholmes.github.io"
        "appindicatorsupport@rgcjonas.gmail.com"
        "caffeine@patapon.info"
        "advanced-media-controller@sanjai.com"
        "top-bar-organizer@julian.gse.jsts.xyz"
        "azwallpaper@azwallpaper.gitlab.com"
      ];
    };
  };
}
