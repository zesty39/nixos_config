{ config, lib, pkgs, targetUser, ... }:

{
  config = lib.mkIf config.application.steam.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraPackages = with pkgs; [
        gamemode
        gamescope
        mangohud
      ];
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
    users.users.${targetUser}.extraGroups = [ "gamemode" ];

    environment.systemPackages = [ pkgs.mangohud ];
  };
}
