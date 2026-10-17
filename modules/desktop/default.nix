{ lib, ... }:

{
  imports = [ ./gnome ];

  options.desktop.gnome = {
    enabled = lib.mkEnableOption "the GNOME desktop";
    dynamic_wallpaper.enabled = lib.mkEnableOption "dynamic wallpapers with scheduled synchronization";
  };
}
