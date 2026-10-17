{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.application.animeko.enable {
    environment.systemPackages = [ (pkgs.callPackage ./package.nix { }) ];
  };
}
