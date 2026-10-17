{ lib, pkgs }:

let
  extensionPackages = with pkgs.gnomeExtensions; [
    user-themes
    blur-my-shell
    (paperwm.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./resources/paperwm-wallpaper-transition.patch ];
    }))
    removable-drive-menu
    dash-to-dock
    gsconnect
    appindicator
    caffeine
    advanced-media-controller
    top-bar-organizer
    (wallpaper-slideshow.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./resources/double-click.patch ];
    }))
  ];

  schemaPackage = pkgs.runCommand "gnome-extension-gsettings-schemas"
    {
      nativeBuildInputs = [ pkgs.glib.dev ];
    }
    ''
      schema_dir="$out/share/gsettings-schemas/gnome-extension-gsettings-schemas/glib-2.0/schemas"
      mkdir -p "$schema_dir"

      for schema in ${lib.concatMapStringsSep " " (package: "${package}/share/gnome-shell/extensions/*/schemas/*.gschema.xml") extensionPackages}; do
        [ -e "$schema" ] || continue
        cp "$schema" "$schema_dir/"
      done

      glib-compile-schemas "$schema_dir"
    '';
in
{
  inherit extensionPackages schemaPackage;
}
