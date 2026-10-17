{ config, inputs, lib, pkgs, themeName, ... }:

let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.spicetify.nixosModules.spicetify ];

  config = lib.mkIf config.application.spotify.enable {
    programs.spicetify = {
      enable = true;
    } // lib.optionalAttrs (themeName == "catppuccin-mocha") {
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };

    environment.systemPackages = [ pkgs.spicetify-cli ];
  };
}
