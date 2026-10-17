{ lib, pkgs, targetUser, sharedLib, ... }:

let
  dconf = sharedLib.dconf;

  rimeIce = pkgs.symlinkJoin {
    name = "rime-ice-with-default";
    paths = [ pkgs.rime-ice ];
    postBuild = ''
      ln -s rime_ice_suggestion.yaml "$out/share/rime-data/default.yaml"
    '';
  };

  rime =
    (pkgs.ibus-engines.rime.override {
      rimeDataPkgs = [
        rimeIce
        pkgs.rime-japanese
      ];
    }).overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [
        ./resources/manual-deployment.patch
      ];
    });
in
{
  services.xserver.xkb = {
    layout = "us";
    options = "ctrl:nocaps";
    variant = "";
  };

  i18n.inputMethod.ibus.engines = [ rime ];

  home-manager.users.${targetUser}.home.file = {
    ".config/ibus/rime/default.custom.yaml" = {
      source = ./resources/default.custom.yaml;
    };
    ".config/ibus/rime/japanese.custom.yaml" = {
      source = ./resources/japanese.custom.yaml;
    };
    ".config/ibus/rime/rime_ice.custom.yaml" = {
      source = ./resources/rime_ice.custom.yaml;
    };
  };

  programs.dconf.profiles.user.databases = dconf.mkLockedDatabases {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "ctrl:nocaps" ];
      mru-sources = [ (lib.gvariant.mkTuple [ "ibus" "rime" ]) ];
      sources = [ (lib.gvariant.mkTuple [ "ibus" "rime" ]) ];
    };
  };
}
