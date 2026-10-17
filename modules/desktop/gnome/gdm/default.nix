{ inputs, lib, pkgs, targetUser, themeName, sharedLib, ... }:

let
  dconf = sharedLib.dconf;
  themePackages = import ../theme/packages.nix { inherit pkgs; };
  extension = import ./extension.nix { inherit inputs pkgs; };
  shellThemeName = themePackages.shellThemeName;
in
{
  config = lib.mkMerge [
    {
      services.displayManager.gdm.enable = true;

      system.activationScripts."${targetUser}Face".text = ''
        install -Dm0644 ${./resources/face.png} /var/lib/AccountsService/icons/${targetUser}
        install -Dm0600 /dev/stdin /var/lib/AccountsService/users/${targetUser} <<'EOF'
        [User]
        Icon=/var/lib/AccountsService/icons/${targetUser}
        SystemAccount=false
        EOF
      '';
    }
    (lib.mkIf (themeName == "catppuccin-mocha") {
      environment.systemPackages = [ extension.gdmExtension ];
      services.displayManager.gdm.extraPackages = [
        (lib.hiPrio themePackages.catppuccinTheme)
        extension.gdmExtension
      ];

      programs.dconf.profiles.gdm.databases = dconf.mkLockedDatabases {
        "org/gnome/shell" = {
          enabled-extensions = [
            extension.gdmExtensionUuid
          ];
        };

        "org/gnome/shell/extensions/gdm-extension" = {
          background-image-path-1 = "none";
          background-image-path-2 = "none";
          background-image-path-3 = "none";
          background-image-path-4 = "none";
          background-size-1 = "cover";
          background-size-2 = "cover";
          background-size-3 = "cover";
          background-size-4 = "cover";
          blur-radius-1 = lib.gvariant.mkInt32 0;
          blur-radius-2 = lib.gvariant.mkInt32 0;
          blur-radius-3 = lib.gvariant.mkInt32 0;
          blur-radius-4 = lib.gvariant.mkInt32 0;
          gradient-direction-1 = "none";
          gradient-direction-2 = "none";
          gradient-direction-3 = "none";
          gradient-direction-4 = "none";
          hide-gdm-extension-button = true;
          primary-color-1 = "#1E1E2E";
          primary-color-2 = "#1E1E2E";
          primary-color-3 = "#1E1E2E";
          primary-color-4 = "#1E1E2E";
          secondary-color-1 = "#1E1E2E";
          secondary-color-2 = "#1E1E2E";
          secondary-color-3 = "#1E1E2E";
          secondary-color-4 = "#1E1E2E";
          shell-theme = shellThemeName;
        };

        "org/gnome/desktop/interface" = {
          cursor-theme = "catppuccin-mocha-dark-cursors";
        };
      };
    })
  ];
}
