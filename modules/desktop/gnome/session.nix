{ config, lib, pkgs, targetUser, ... }:

{
  config = lib.mkIf (config.desktop.gnome.enabled) {
    services.xserver.enable = false;
    programs.xwayland.enable = true;
    services.displayManager.defaultSession = "gnome";
    services.desktopManager.gnome.enable = true;

    services.displayManager.autoLogin = {
      enable = true;
      user = targetUser;
    };

    environment.gnome.excludePackages = with pkgs; [
      decibels
      epiphany
      firefox
      gnome-console
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-text-editor
      gnome-tour
      simple-scan
      showtime
      system-config-printer
      yelp
    ];

    environment.systemPackages = with pkgs; [
      celluloid
      gnome-tweaks
    ];
  };
}
