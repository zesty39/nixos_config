{ pkgs }:

let
  version = "5.5.2";
  baseUrl = "https://github.com/coddingtonbear/obsidian-local-rest-api/releases/download/${version}";
  main = pkgs.fetchurl {
    url = "${baseUrl}/main.js";
    hash = "sha256-kElLZETF/t5dEvlzRqq4OSZbXHoJUg/oe078IjYLbNg=";
  };
  manifest = pkgs.fetchurl {
    url = "${baseUrl}/manifest.json";
    hash = "sha256-LORt+h7pthUN2N0NvMaGNu4V1UM/mj+iTptsyERuviU=";
  };
  styles = pkgs.fetchurl {
    url = "${baseUrl}/styles.css";
    hash = "sha256-GZVt6vTRQUI4H4H9+SyugkH9CqCKGjpUZLDQB7rhkk0=";
  };
in
pkgs.runCommand "obsidian-local-rest-api-${version}" {
  passthru.manifestId = "obsidian-local-rest-api";
} ''
  mkdir -p "$out"
  ln -s ${main} "$out/main.js"
  ln -s ${manifest} "$out/manifest.json"
  ln -s ${styles} "$out/styles.css"
''
