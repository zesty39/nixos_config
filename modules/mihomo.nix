{ pkgs, targetUser, ... }:

let
  mihomoGenConfig = pkgs.writeShellApplication {
    name = "mihomo-gen-config";
    runtimeInputs = [ pkgs.coreutils pkgs.gnused pkgs.mihomo ];
    text = builtins.readFile ./resources/mihomo/mihomo-gen-config.sh;
  };
in
{
  services.openssh.enable = true;

  users.groups.mihomo-config = { };
  users.users.${targetUser}.extraGroups = [ "mihomo-config" ];

  networking.networkmanager.enable = true;
  networking.resolvconf.dnsExtensionMechanism = false;
  networking.usePredictableInterfaceNames = false;
  services.resolved.enable = true;

  systemd.tmpfiles.rules = [
    "d /etc/mihomo 2770 root mihomo-config -"
  ];

  environment.etc."mihomo/template.yaml".source = ./resources/mihomo/template.yaml;

  environment.systemPackages = [
    pkgs.mihomo
    mihomoGenConfig
  ];

  services.mihomo = {
    enable = true;
    configFile = "/etc/mihomo/config.yaml";
    tunMode = true;
  };

  systemd.services.mihomo = {
    unitConfig.ConditionPathExists = "/etc/mihomo/config.yaml";
  };

  systemd.services.mihomo-dns = {
    description = "Register Mihomo DNS with systemd-resolved";
    after = [ "mihomo.service" "systemd-resolved.service" ];
    requires = [ "mihomo.service" "systemd-resolved.service" ];
    partOf = [ "mihomo.service" "systemd-resolved.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      for ((retry = 0; retry < 50; retry++)); do
        if ${pkgs.iproute2}/bin/ip link show mihomo-tun0 >/dev/null 2>&1; then
          ${pkgs.systemd}/bin/resolvectl dns mihomo-tun0 198.18.0.2
          ${pkgs.systemd}/bin/resolvectl domain mihomo-tun0 '~.'
          exit 0
        fi
        ${pkgs.coreutils}/bin/sleep 0.1
      done

      echo "mihomo-tun0 was not created" >&2
      exit 1
    '';
  };

  networking.firewall.trustedInterfaces = [ "mihomo-tun0" ];
}
