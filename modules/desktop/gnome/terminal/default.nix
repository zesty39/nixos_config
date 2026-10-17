{ inputs, lib, pkgs, targetUser, themeName, sharedLib, ... }:

let
  dconf = sharedLib.dconf;

  blackboxSchemeName = "Catppuccin Mocha";
  catppuccinTilix = inputs.catppuccin-tilix;
in
{
  imports = [ sharedLib.nixosModules.dconf-keybindings ];

  programs.dconf.customKeybindings.blackbox = {
    name = "Black Box";
    command = "blackbox";
    binding = "<Super>Return";
  };

  environment.systemPackages = [ pkgs.blackbox-terminal ];

  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "com.raggesilver.BlackBox.desktop" ];
  };

  home-manager.users.${targetUser} = {
    home.file = lib.mkIf (themeName == "catppuccin-mocha") {
      ".local/share/blackbox/schemes/catppuccin-mocha.json".source =
        "${catppuccinTilix}/themes/catppuccin-mocha.json";
    };

    xdg.configFile."gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-cursor-aspect-ratio=0.15
    '';
  };

  programs.dconf.profiles.user.databases = dconf.mkLockedDatabases {
    "com/raggesilver/BlackBox" = {
      cursor-blink-mode = lib.gvariant.mkUint32 1;
      cursor-shape = lib.gvariant.mkUint32 2;
      terminal-padding = lib.gvariant.mkTuple (
        map lib.gvariant.mkUint32 [ 10 10 10 10 ]
      );
    } // lib.optionalAttrs (themeName == "catppuccin-mocha") {
      style-preference = lib.gvariant.mkUint32 2;
      theme-dark = blackboxSchemeName;
      theme-light = blackboxSchemeName;
    };
  };
}
