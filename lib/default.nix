{ lib }:

{
  dconf = import ./dconf.nix { inherit lib; };

  nixosModules.dconf-keybindings = ./dconf-keybindings.nix;
}
