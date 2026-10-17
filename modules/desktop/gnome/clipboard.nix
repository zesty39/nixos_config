{ config, lib, ... }:

{
  config = lib.mkIf (config.desktop.gnome.enabled) {
    programs.gpaste.enable = true;
  };
}
