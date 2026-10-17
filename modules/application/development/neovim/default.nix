{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.application.neovim.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = false;
      nixpkgs.pkgs = pkgs;
      imports = [ ./config ];
    };
    environment.variables.EDITOR = "vi";
  };
}
