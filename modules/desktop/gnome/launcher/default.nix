{ config, inputs, lib, pkgs, targetUser, themeName, sharedLib, ... }:

let
  ulauncherThemeName = "Catppuccin-Mocha-Mauve";

  catppuccinUlauncher = inputs.catppuccin-ulauncher;
  ulauncherTheme = pkgs.runCommand "ulauncher-catppuccin-mocha-mauve-theme" { } ''
    TASK_HOME="$TMPDIR/home"
    mkdir -p "$TASK_HOME/bin" "$TASK_HOME"
    ln -s ${pkgs.ulauncher}/bin/ulauncher "$TASK_HOME/bin/ulauncher"

    env HOME="$TASK_HOME" PATH="${pkgs.python3}/bin:$TASK_HOME/bin:$PATH" \
      ${pkgs.python3}/bin/python ${catppuccinUlauncher}/install.py \
        --flavor mocha \
        --accent mauve \
        --radius 12

    for theme_file in manifest.json theme.css theme-gtk-3.20.css; do
      test -s "$TASK_HOME/.config/ulauncher/user-themes/${ulauncherThemeName}/$theme_file"
    done

    substituteInPlace "$TASK_HOME/.config/ulauncher/user-themes/${ulauncherThemeName}/theme.css" \
      --replace-fail "Catpuccin colors" "Catppuccin colors"

    mkdir -p "$out"
    cp -r "$TASK_HOME/.config/ulauncher/user-themes/${ulauncherThemeName}" "$out/"
  '';

  scriptPrefix = name: variables: ''
    # --- HELP BEGIN ---
    # Usage: ${name} [--help]
    # Options:
    #   -h, --help  Show this help message.
    # --- HELP END ---
    set -euo pipefail

    SCRIPT_DIR="$(${pkgs.coreutils}/bin/dirname "$0")"
    SCRIPT_NAME="$(${pkgs.coreutils}/bin/basename "$0")"
    ${variables}
    readonly SCRIPT_DIR
    readonly SCRIPT_NAME

    print_usage() {
      ${pkgs.gnused}/bin/sed -n \
        -e '/^# --- HELP BEGIN ---$/,/^# --- HELP END ---$/!d' \
        -e '/^# --- HELP BEGIN ---$/d' \
        -e '/^# --- HELP END ---$/d' \
        -e 's/^# //' -e 'p' "$SCRIPT_DIR/$SCRIPT_NAME"
    }

    error() {
      printf '[ERROR]: %s\n' "$*" >&2
      exit 2
    }
  '';

  helpOnlyArguments = ''
    case "$#" in
      0) ;;
      1)
        case "$1" in
          -h|--help) print_usage; exit 0 ;;
          *) error "Unknown option: $1" ;;
        esac
        ;;
      *) error "This script accepts only --help" ;;
    esac
  '';

  suppressHotkeyNotification = pkgs.writeShellScript "ulauncher-suppress-hotkey-notification" ''
    ${scriptPrefix "ulauncher-suppress-hotkey-notification" ''
      CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/ulauncher_cache"
      CACHE_FILE="$CACHE_DIR/app_cache.db"

      readonly CACHE_DIR
      readonly CACHE_FILE
    ''}
    ${helpOnlyArguments}

    mkdir -p "$CACHE_DIR"

    ${pkgs.python3}/bin/python ${./resources/suppress-hotkey-notification.py} "$CACHE_FILE"
  '';

  startUlauncher = pkgs.writeShellScript "start-ulauncher" ''
    ${scriptPrefix "start-ulauncher" ""}
    ${helpOnlyArguments}

    ${suppressHotkeyNotification}
    exec ${pkgs.coreutils}/bin/env GDK_BACKEND=x11 ${pkgs.ulauncher}/bin/ulauncher --hide-window
  '';
in
{
  imports = [ sharedLib.nixosModules.dconf-keybindings ];


  config = lib.mkIf (config.desktop.gnome.enabled) {
    programs.dconf.customKeybindings.ulauncher = {
      name = "Ulauncher";
      command = "ulauncher-toggle";
      binding = "<Super>slash";
    };

    environment.systemPackages = [ pkgs.ulauncher ];

    systemd.user.services.ulauncher.enable = false;

    home-manager.users.${targetUser}.home.file = {
      ".config/ulauncher/extensions.json".text = builtins.toJSON {
        "com.github.tjquillan.ulauncher-system" = {
          id = "com.github.tjquillan.ulauncher-system";
          url = "https://github.com/tjquillan/ulauncher-system";
          updated_at = "2026-10-11T00:00:00.000000";
          last_commit = inputs.ulauncher-system.rev;
          last_commit_time = "2023-11-14T16:53:20";
        };
      };

      ".config/ulauncher/settings.json".text = builtins.toJSON ({
        blacklisted-desktop-dirs = "/usr/share/locale:/usr/share/app-install:/usr/share/kservices5:/usr/share/fk5:/usr/share/kservicetypes5:/usr/share/applications/screensavers:/usr/share/kde4:/usr/share/mimelnk";
        clear-previous-query = true;
        disable-desktop-filters = false;
        grab-mouse-pointer = false;
        hotkey-show-app = "<Primary>space";
        render-on-screen = "mouse-pointer-monitor";
        show-indicator-icon = false;
        show-recent-apps = "0";
        terminal-command = "";
      } // lib.optionalAttrs (themeName == "catppuccin-mocha") {
        theme-name = ulauncherThemeName;
      });

      ".local/share/ulauncher/extensions/com.github.tjquillan.ulauncher-system".source =
        inputs.ulauncher-system;

      ".config/autostart/ulauncher.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Ulauncher
        Comment=Linux Application Launcher
        Exec=${startUlauncher}
        Terminal=false
        X-GNOME-Autostart-enabled=true
        X-GNOME-Autostart-Delay=3
      '';
    } // lib.optionalAttrs (themeName == "catppuccin-mocha") {
      ".config/ulauncher/user-themes/${ulauncherThemeName}/manifest.json".source =
        "${ulauncherTheme}/${ulauncherThemeName}/manifest.json";
      ".config/ulauncher/user-themes/${ulauncherThemeName}/theme.css".source =
        "${ulauncherTheme}/${ulauncherThemeName}/theme.css";
      ".config/ulauncher/user-themes/${ulauncherThemeName}/theme-gtk-3.20.css".source =
        "${ulauncherTheme}/${ulauncherThemeName}/theme-gtk-3.20.css";
    };
  };
}
