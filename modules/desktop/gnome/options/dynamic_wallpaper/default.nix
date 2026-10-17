{ config, lib, pkgs, targetUser, ... }:

let
  wallpaperExtension = pkgs.gnomeExtensions.wallpaper-slideshow.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./resources/double-click.patch ];
  });
  wallpaperDirectory = "/home/${targetUser}/Pictures/Wallpapers/minori";
  syncWallpapers = pkgs.writeScriptBin "sekai-wallpapers-sync" ''
    #!${pkgs.python3.withPackages (ps: [ ps.pillow ])}/bin/python3
    ${builtins.readFile ./resources/sync.py}
  '';
in
{
  config = lib.mkIf (config.desktop.gnome.enabled && config.desktop.gnome.dynamic_wallpaper.enabled) {
    environment.systemPackages = [ syncWallpapers ];
    desktop.gnome.extraExtensions = [ wallpaperExtension ];

    home-manager.users.${targetUser} = { lib, ... }: {
      home.activation.createWallpaperDirectory = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir -p ${lib.escapeShellArg wallpaperDirectory}
      '';

      dconf.settings."org/gnome/shell/extensions/azwallpaper" = {
        slideshow-directory = wallpaperDirectory;
        slideshow-queue-sort-type = "Random";
        slideshow-slide-duration = lib.gvariant.mkTuple (map lib.gvariant.mkInt32 [ 0 30 0 ]);
        bing-wallpaper-download = false;
        update-notifier-enabled = false;
      };

      systemd.user.services.sekai-wallpapers-sync = {
        Unit.Description = "Synchronize Minori card wallpapers from Sekai Viewer";
        Service = {
          Type = "simple";
          ExecStart = "${syncWallpapers}/bin/sekai-wallpapers-sync --directory ${wallpaperDirectory} --interval-days 15 --state-file %S/sekai-wallpapers-sync/next-sync.json";
          StateDirectory = "sekai-wallpapers-sync";
          Restart = "on-failure";
          RestartSec = "1min";
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
  };
}
