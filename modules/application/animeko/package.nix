{ lib, appimageTools, fetchurl }:

let
  pname = "animeko";
  version = "6.3.0";
  src = fetchurl {
    url = "https://github.com/open-ani/animeko/releases/download/v${version}/ani-${version}-linux-x86_64.appimage";
    hash = "sha256:7bba966c8d2b0d4ac6a3cd2b3a08357c0b7a1b2ecbe9e8ee20b7f1b09c3c9be1";
  };
  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  profile = ''
    # Chromium needs additional static TLS space when loaded into the JVM.
    export GLIBC_TUNABLES="''${GLIBC_TUNABLES:+$GLIBC_TUNABLES:}glibc.rtld.optional_static_tls=2048"
  '';

  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/animeko.desktop $out/share/applications/animeko.desktop
    substituteInPlace $out/share/applications/animeko.desktop \
      --replace-fail "Exec=Ani" "Exec=animeko" \
      --replace-fail "Icon=icon" "Icon=animeko"
    install -Dm644 ${appimageContents}/icon.png $out/share/icons/hicolor/512x512/apps/animeko.png
  '';

  meta = {
    description = "Anime streaming application with Bangumi tracking and danmaku";
    homepage = "https://github.com/open-ani/animeko";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "animeko";
  };
}
