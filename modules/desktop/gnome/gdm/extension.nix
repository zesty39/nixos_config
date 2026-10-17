{ inputs, pkgs }:

let
  gdmExtensionUuid = "gdm-extension@pratap.fastmail.fm";

  gdmExtension = pkgs.stdenvNoCC.mkDerivation {
    pname = "gse-gdm-extension";
    version = inputs.gdm-extension.shortRev;

    src = inputs.gdm-extension;

    nativeBuildInputs = [ pkgs.glib.dev ];

    installPhase = ''
      runHook preInstall

      extension_dir="$out/share/gnome-shell/extensions/${gdmExtensionUuid}"
      mkdir -p "$extension_dir"
      cp -r src/v-45-46-47-48-49-50/. "$extension_dir/"
      chmod -R u+w "$extension_dir"

      substituteInPlace "$extension_dir/extension.js" \
        --replace-fail "import Gio from 'gi://Gio';" "import Gio from 'gi://Gio';"$'\n'"import GLib from 'gi://GLib';" \
        --replace-fail "const THEME_DIRECTORIES = ['/usr/local/share/themes', '/usr/share/themes'];" "const THEME_DIRECTORIES = GLib.get_system_data_dirs().map(dir => \`\''${dir}/themes\`);" \
        --replace-fail "Main.setThemeStylesheet(themeName);" "const stylesheetPaths = THEME_DIRECTORIES.map(dir => \`\''${dir}/\''${themeName}/gnome-shell/gnome-shell.css\`);"$'\n'"            const styleSheet = stylesheetPaths.find(path => Gio.file_new_for_path(path).query_exists(null));"$'\n'"            Main.setThemeStylesheet(styleSheet);"

      substituteInPlace "$extension_dir/menus/shellThemesMenu.js" \
        --replace-fail "import Gio from 'gi://Gio';" "import Gio from 'gi://Gio';"$'\n'"import GLib from 'gi://GLib';" \
        --replace-fail "const THEME_DIRECTORIES = ['/usr/local/share/themes', '/usr/share/themes'];" "const THEME_DIRECTORIES = GLib.get_system_data_dirs().map(dir => \`\''${dir}/themes\`);"

      substituteInPlace "$extension_dir/getNamesAsync/getShellThemes.js" \
        --replace-fail "const THEME_DIRECTORIES = ['/usr/local/share/themes', '/usr/share/themes'];" "const THEME_DIRECTORIES = GLib.get_system_data_dirs().map(dir => \`\''${dir}/themes\`);"

      glib-compile-schemas "$extension_dir/schemas"

      runHook postInstall
    '';
  };
in
{
  inherit gdmExtension gdmExtensionUuid;
}
