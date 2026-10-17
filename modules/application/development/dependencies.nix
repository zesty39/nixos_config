{ lib, pkgs }:

let
  defaultDependencies = with pkgs; [
    coreutils
    curl
    fd
    file
    git
    patchelf
    ripgrep
    unzip
    wget
    xdotool
    xdg-utils
  ];
  languageDependencies = {
    c-cpp = with pkgs; [
      clang-tools
      gnumake
      pkg-config
      stdenv.cc
    ];
    rust = with pkgs; [
      cargo
      cargo-tauri
      clippy
      libayatana-appindicator
      librsvg
      openssl
      rust-analyzer
      rustc
      rustfmt
      webkitgtk_4_1
    ];
    nodejs = with pkgs; [
      nodejs
      pnpm
      typescript
      typescript-language-server
    ];
    python = with pkgs; [
      pyright
      python3
    ];
  };
  bspDependencies = with pkgs; [
    android-tools
    autoconf
    automake
    bc
    bison
    cmake
    cpio
    dosfstools
    dtc
    e2fsprogs
    flex
    gdb
    gperf
    iperf3
    libtool
    meson
    mtdutils
    netcat-openbsd
    ninja
    nmap
    parted
    rsync
    socat
    squashfsTools
    tcpdump
    ubootTools
    usbutils
    uucp
  ];
  agentDependencies = with pkgs; [
    bubblewrap
  ];
  developmentDependencies = lib.unique (
    defaultDependencies
    ++ lib.concatLists (builtins.attrValues languageDependencies)
    ++ bspDependencies
    ++ agentDependencies
  );
in
{
  inherit defaultDependencies languageDependencies bspDependencies agentDependencies developmentDependencies;
}
