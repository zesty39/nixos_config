{ config, inputs, lib, targetUser, themeName, ... }:

{
  config = lib.mkIf config.application.zen-browser.enable {
    home-manager.users.${targetUser} = {
      imports = [
        inputs.zen-browser.homeModules.twilight
      ];

      programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = true;

        policies.ExtensionSettings = {
          "disable-html5-autoplay@afnankhan" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4271494/disable_autoplay-2018.10.4resigned1.xpi";
            installation_mode = "normal_installed";
          };
          "{5efceaa7-f3a2-4e59-a54b-85319448e305}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4844745/immersive_translate-1.30.2.xpi";
            installation_mode = "normal_installed";
          };
          "tridactyl.vim@cmcaine.co.uk" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4854935/tridactyl_vim-1.24.6.xpi";
            installation_mode = "normal_installed";
          };
          "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4970801/styl_us-2.4.11.xpi";
            installation_mode = "normal_installed";
          };
        };

        profiles.default = {
          id = 0;
          isDefault = true;
          name = "default";
          path = "default";

          settings = {
            "zen.view.compact.enable-at-startup" = false;
            "zen.view.sidebar-expanded" = false;
            "zen.view.use-single-toolbar" = false;
            "zen.welcome-screen.seen" = true;
          } // lib.optionalAttrs (themeName == "catppuccin-mocha") {
            "browser.theme.content-theme" = 0;
            "browser.theme.toolbar-theme" = 0;
            "layout.css.prefers-color-scheme.content-override" = 0;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "ui.systemUsesDarkTheme" = 1;
          };
        } // lib.optionalAttrs (themeName == "catppuccin-mocha") {
          presets.catppuccin = {
            enable = true;
            flavor = "Mocha";
            accent = "Mauve";
          };
        };
      };

      home.file = {
        ".config/zen/default/zen-keyboard-shortcuts.json" = {
          force = true;
          source = ./resources/keyboard-shortcuts.json;
        };
      };
    };
  };
}
