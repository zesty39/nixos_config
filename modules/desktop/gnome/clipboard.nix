{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (config.desktop.gnome.enabled) {
    environment.systemPackages = [ pkgs.wl-clipboard ];
    programs.gpaste.enable = true;
  };
}
