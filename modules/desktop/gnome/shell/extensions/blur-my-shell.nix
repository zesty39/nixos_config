{ lib, sharedLib, ... }:

let
  dconf = sharedLib.dconf;
  blurDisabledSettings = lib.genAttrs [
    "org/gnome/shell/extensions/blur-my-shell/appfolder"
    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock"
    "org/gnome/shell/extensions/blur-my-shell/panel"
  ] (_: { blur = false; });
in
{
  programs.dconf.profiles.user.databases = dconf.mkLockedDatabases ({
    "org/gnome/shell/extensions/blur-my-shell" = {
      settings-version = lib.gvariant.mkInt32 2;
    };
  } // blurDisabledSettings);
}
