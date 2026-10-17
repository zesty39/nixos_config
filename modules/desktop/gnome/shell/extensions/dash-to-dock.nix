{ lib, sharedLib, ... }:

let
  dconf = sharedLib.dconf;
in
{
  programs.dconf.profiles.user.databases = dconf.mkLockedDatabases {
    "org/gnome/shell/extensions/dash-to-dock" = {
      disable-overview-on-startup = true;
      hide-tooltip = true;
      intellihide = false;
      show-icons-emblems = false;
      show-icons-notifications-counter = false;
    };
  };
}
