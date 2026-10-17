{ config, lib, pkgs, ... }:

let
  dependencies = import ./dependencies.nix { inherit lib pkgs; };
in
{
  imports = [
    ./neovim
    ./zed
  ];

  options.development.enable = lib.mkEnableOption "the shared development environment";

  config = lib.mkMerge [
    (lib.mkIf (config.application.neovim.enable || config.application.zed.enable) {
      development.enable = lib.mkDefault true;
    })
    (lib.mkIf config.development.enable {
      environment.systemPackages = dependencies.developmentDependencies;
      programs.nix-ld.enable = true;
      environment.sessionVariables.PKG_CONFIG_PATH =
        lib.makeSearchPathOutput "dev" "lib/pkgconfig" dependencies.languageDependencies.rust;
    })
  ];
}
