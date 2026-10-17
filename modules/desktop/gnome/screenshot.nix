{ lib, targetUser, themeName, sharedLib, ... }:

let
  dconf = sharedLib.dconf;
in
{
  imports = [ sharedLib.nixosModules.dconf-keybindings ];

  programs.dconf.customKeybindings.flameshot = {
    name = "Flameshot";
    command = "flameshot gui";
    binding = "<Super><Shift>s";
  };

  programs.dconf.profiles.user.databases = dconf.mkLockedDatabases {
    "org/gnome/shell/keybindings" = {
      screenshot = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
      screenshot-window = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
      show-screenshot-ui = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
    };
  };

  home-manager.users.${targetUser}.services.flameshot = {
    enable = true;
    settings.General = {
      showStartupLaunchMessage = false;
    } // lib.optionalAttrs (themeName == "catppuccin-mocha") {
      uiColor = "#cba6f7";
      contrastUiColor = "#1e1e2e";
      drawColor = "#f38ba8";
    };
  };
}
