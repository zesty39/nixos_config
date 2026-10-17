{ targetUser, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system.nix
    ../../modules/application
    ../../modules/mihomo.nix
    ./fingerprint.nix
    ../../modules/desktop
  ];

  desktop.gnome = {
    enabled = true;
    dynamic_wallpaper.enabled = false;
  };

  development.enable = true;

  application = {
    neovim.enable = true;
    zed.enable = true;
    zen-browser.enable = true;
    spotify.enable = true;
    steam.enable = true;
    zsh.enable = true;
    distrobox.enable = true;
    kazumi.enable = true;
    libreoffice.enable = true;
    yt-dlp.enable = true;
    ffmpeg.enable = true;
  };

  _module.args.themeName = "catppuccin-mocha";

  networking.hostName = "XPS13";
  nixpkgs.hostPlatform = "x86_64-linux";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm-backup";
  home-manager.users.${targetUser}.home.stateVersion = "26.05";

  system.stateVersion = "26.05";
}
