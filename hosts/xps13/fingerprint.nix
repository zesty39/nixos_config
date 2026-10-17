{ inputs, pkgs, ... }:

let
  goodix53x5Source = inputs.goodix53x5;

  libfprintGoodix53x5 = pkgs.libfprint.overrideAttrs (oldAttrs: {
    postPatch = (oldAttrs.postPatch or "") + ''
      # Apply the integration for libfprint 1.94.100 before copying driver sources.
      patch --dry-run -p1 < ${./resources/fingerprint/goodix53x5-meson-integration.patch}
      patch -p1 < ${./resources/fingerprint/goodix53x5-meson-integration.patch}
      ${pkgs.bash}/bin/bash ${goodix53x5Source}/install.sh .
      grep -Fq "'goodix53x5' :" libfprint/meson.build
      grep -Fq "goodix53x5-commands.c" libfprint/meson.build
      grep -Fq "link_with: [libfprint_private, libsigfm]" libfprint/meson.build
      grep -Fq "link_with: [libfprint_drivers, libfprint_private, libsigfm]" libfprint/meson.build
      grep -Fq "dependencies: deps + [opencv_dep]" libfprint/meson.build
      grep -Fq "'goodix53x5': { 'helper': ['openssl'] }" meson.build
      substituteInPlace libfprint/drivers/goodix53x5/goodix53x5-session.c \
        --replace-fail '#define GOODIX_OPEN_FDT_MAX_RETRIES 2' '#define GOODIX_OPEN_FDT_MAX_RETRIES 10' \
        --replace-fail 'fpi_ssm_jump_to_state (ssm, GOODIX_OPEN_FDT_TX_ON_2);' 'fpi_ssm_jump_to_state_delayed (ssm, GOODIX_OPEN_FDT_TX_ON_2, 100);'
    '';

    buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ pkgs.opencv ];
  });

  fprintdGoodix53x5 = pkgs.fprintd.override {
    libfprint = libfprintGoodix53x5;
  };
in
{
  services.desktopManager.gnome = {
    extraGSettingsOverridePackages = [ pkgs.gdm ];
    extraGSettingsOverrides = ''
      [org.gnome.login-screen]
      enable-fingerprint-authentication=true
    '';
  };

  services.fprintd = {
    enable = true;
    package = fprintdGoodix53x5;
  };
}
