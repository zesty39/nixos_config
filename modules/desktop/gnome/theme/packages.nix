{ pkgs }:

let
  shellThemeName = "Catppuccin-GTK-Mauve-Dark-MB";

  catppuccinGtk = pkgs.magnetic-catppuccin-gtk.override {
    accent = [ "mauve" ];
    shade = "dark";
    size = "standard";
    tweaks = [ "macos" ];
  };

  catppuccinTheme = pkgs.runCommand "catppuccin-theme-with-gdm-login-overrides" { } ''
    mkdir -p "$out"
    cp -r ${catppuccinGtk}/share "$out/"
    chmod -R u+w "$out"
    cat ${./resources/gdm-login.css} >> "$out/share/themes/${shellThemeName}/gnome-shell/gnome-shell.css"
  '';

  papirusIconTheme = pkgs.catppuccin-papirus-folders.override {
    flavor = "mocha";
    accent = "mauve";
  };
in
{
  inherit catppuccinTheme papirusIconTheme shellThemeName;
}
