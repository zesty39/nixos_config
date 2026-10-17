{ config, lib, pkgs, targetUser, themeName, ... }:

{
  config = lib.mkIf config.application.zed.enable {
    environment.systemPackages = [ pkgs.zed-editor ];

    home-manager.users.${targetUser}.xdg.configFile = {
      "zed/keymap.json".source = ./resources/keymap.json;
      "zed/settings.json".text =
        lib.removeSuffix "}" (lib.trim (builtins.readFile ./resources/settings.json))
        + lib.optionalString (themeName == "catppuccin-mocha") ''
          "icon_theme": {
            "mode": "system",
            "light": "Catppuccin Latte",
            "dark": "Catppuccin Mocha"
          },
          "auto_install_extensions": {
            "catppuccin": true,
            "catppuccin-icons": true
          },
          "theme": {
            "mode": "system",
            "light": "Catppuccin Latte",
            "dark": "Catppuccin Mocha - No Italics"
          },
        ''
        + "}\n";
      "zed/snippets/rust.json".source = ./resources/snippets/rust.json;
    };
  };
}
