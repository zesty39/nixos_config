{ config, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "nix-temp-run";
      runtimeInputs = [
        config.nix.package
        pkgs.bash
        pkgs.bubblewrap
        pkgs.coreutils
        pkgs.gnused
      ];
      text = builtins.readFile ./resources/nix-temp-run.sh;
    })
  ];
}
