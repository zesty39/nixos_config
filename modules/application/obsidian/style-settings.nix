{ pkgs }:

let
  version = "1.0.9";
  baseUrl = "https://github.com/community-archive/obsidian-style-settings/releases/download/${version}";
  main = pkgs.fetchurl {
    url = "${baseUrl}/main.js";
    hash = "sha256-GCirqs2rTFV4twWmJcWFswUS+O+tTHz8WhjnDMNVdGg=";
  };
  manifest = pkgs.fetchurl {
    url = "${baseUrl}/manifest.json";
    hash = "sha256-nP/cIM8qoTVIIOAFC2lLD5tXZEbj1dRKNq6LAYflv7g=";
  };
  styles = pkgs.fetchurl {
    url = "${baseUrl}/styles.css";
    hash = "sha256-7nk30r5QZTqJzLMK5fBXKyNQfVt/EyjQBScaNjB1v9g=";
  };
in
pkgs.runCommand "obsidian-style-settings-${version}" {
  passthru.manifestId = "obsidian-style-settings";
} ''
  mkdir -p "$out"
  ln -s ${main} "$out/main.js"
  ln -s ${manifest} "$out/manifest.json"
  ln -s ${styles} "$out/styles.css"
''
