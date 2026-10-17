{ targetUser, ... }:

let
  monitors = ./resources/monitors.xml;
in
{
  home-manager.users.${targetUser}.xdg.configFile."monitors.xml" = {
    source = monitors;
    force = true;
  };

  # Mutter also loads this system-wide configuration in the GDM greeter.
  environment.etc."xdg/monitors.xml".source = monitors;
}
