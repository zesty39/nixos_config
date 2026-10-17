{ config, lib, pkgs, ... }:

{
  config = lib.mkMerge [
    (lib.mkIf config.application.distrobox.enable {
      environment.systemPackages = [ pkgs.distrobox ];
      virtualisation.podman.enable = true;
    })
    (lib.mkIf config.application.libreoffice.enable {
      environment.systemPackages = [ pkgs.libreoffice-fresh ];
    })
    (lib.mkIf config.application.yt-dlp.enable {
      environment.systemPackages = [ pkgs.yt-dlp ];
    })
    (lib.mkIf config.application.ffmpeg.enable {
      environment.systemPackages = [ pkgs.ffmpeg ];
    })
  ];
}
