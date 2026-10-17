{ lib, ... }:

{
  imports = [
    ./development
    ./zen-browser
    ./spotify
    ./steam
    ./zsh
    ./general.nix
  ];

  options.application = {
    neovim.enable = lib.mkEnableOption "the shared Nixvim editor";
    zed.enable = lib.mkEnableOption "Zed";
    zen-browser.enable = lib.mkEnableOption "Zen Browser";
    spotify.enable = lib.mkEnableOption "Spotify with Spicetify";
    steam.enable = lib.mkEnableOption "Steam with gaming support";
    zsh.enable = lib.mkEnableOption "Zsh with Zim";
    distrobox.enable = lib.mkEnableOption "Distrobox with Podman";
    kazumi.enable = lib.mkEnableOption "Kazumi";
    libreoffice.enable = lib.mkEnableOption "LibreOffice";
    yt-dlp.enable = lib.mkEnableOption "yt-dlp";
    ffmpeg.enable = lib.mkEnableOption "FFmpeg";
  };
}
