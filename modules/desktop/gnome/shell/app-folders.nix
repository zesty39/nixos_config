{ config, lib, sharedLib, ... }:

let
  dconf = sharedLib.dconf;

  appPickerItems = [
    "Utilities"
    "System"
    "Offices"
    "com.raggesilver.BlackBox.desktop"
    "dev.zed.Zed.desktop"
    "io.github.celluloid_player.Celluloid.desktop"
    "io.github.Predidit.Kazumi.desktop"
    "org.gnome.Nautilus.desktop"
  ];

  appPickerEntry = position: name:
    lib.gvariant.mkDictionaryEntry name (lib.gvariant.mkVariant [
      (lib.gvariant.mkDictionaryEntry "position" (lib.gvariant.mkVariant (lib.gvariant.mkInt32 position)))
    ]);
in
{
  config = lib.mkIf (config.desktop.gnome.enabled) {
    programs.dconf.profiles.user.databases = dconf.mkLockedDatabases {
      "org/gnome/desktop/app-folders" = {
        folder-children = [ "Utilities" "System" "Offices" ];
      };

      "org/gnome/desktop/app-folders/folders/Utilities" = {
        name = "Utilities";
        apps = [
          "org.gnome.Connections.desktop"
          "org.gnome.Papers.desktop"
          "org.gnome.Snapshot.desktop"
          "org.gnome.clocks.desktop"
          "org.gnome.Weather.desktop"
          "org.gnome.Calculator.desktop"
          "org.gnome.Loupe.desktop"
          "org.gnome.Calendar.desktop"
          "org.flameshot.Flameshot.desktop"
          "ulauncher.desktop"
          "nvim.desktop"
        ];
      };

      "org/gnome/desktop/app-folders/folders/System" = {
        name = "System";
        apps = [
          "org.gnome.baobab.desktop"
          "org.gnome.DiskUtility.desktop"
          "org.gnome.Logs.desktop"
          "org.gnome.SystemMonitor.desktop"
          "org.gnome.Characters.desktop"
          "org.gnome.font-viewer.desktop"
          "org.gnome.Extensions.desktop"
          "org.gnome.tweaks.desktop"
          "org.gnome.seahorse.Application.desktop"
          "org.gnome.Settings.desktop"
          "nixos-manual.desktop"
          "org.gnome.GPaste.Preferences.desktop"
          "org.gnome.GPaste.Ui.desktop"
        ];
      };

      "org/gnome/desktop/app-folders/folders/Offices" = {
        name = "Offices";
        apps = [
          "startcenter.desktop"
          "writer.desktop"
          "calc.desktop"
          "impress.desktop"
          "draw.desktop"
          "base.desktop"
          "math.desktop"
        ];
      };

      "org/gnome/shell" = {
        favorite-apps = [
          "com.raggesilver.BlackBox.desktop"
          "zen-twilight.desktop"
          "dev.zed.Zed.desktop"
          "org.gnome.Nautilus.desktop"
          "spotify.desktop"
          "steam.desktop"
          "io.github.Predidit.Kazumi.desktop"
        ];
        app-picker-layout = [
          (lib.imap0 appPickerEntry appPickerItems)
        ];
      };
    };
  };
}
