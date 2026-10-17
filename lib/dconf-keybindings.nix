{ config, lib, sharedLib, ... }:

let
  dconf = sharedLib.dconf;
  keybindings = config.programs.dconf.customKeybindings;
  keybindingPath = name:
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${name}";
in
{
  options.programs.dconf.customKeybindings = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        name = lib.mkOption { type = lib.types.str; };
        command = lib.mkOption { type = lib.types.str; };
        binding = lib.mkOption { type = lib.types.str; };
      };
    });
    default = { };
    description = "System-locked GNOME custom shortcuts declared by their owning features.";
  };

  config.programs.dconf.profiles.user.databases = dconf.mkLockedDatabases (
    {
      "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings =
        if keybindings == { } then
          lib.gvariant.mkEmptyArray lib.gvariant.type.string
        else
          map (name: "/${keybindingPath name}/") (builtins.attrNames keybindings);
    }
    // lib.mapAttrs' (name: value: lib.nameValuePair (keybindingPath name) value) keybindings
  );
}
