# Prepared for the GTi13-Ultra (Intel Core i9-13900HK, NVMe, UEFI).
# Filesystems reflect the current machine's UUIDs and Btrfs subvolumes.
# Verify or regenerate this file with nixos-generate-config after mounting
# the target filesystems if the installation changes their UUIDs or layout.
{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b165393d-3971-46dd-8da8-9b8c191d4999";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd:1" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/b165393d-3971-46dd-8da8-9b8c191d4999";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd:1" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1292a632-817d-4f9c-befb-2ab06add8817";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/3090-7413";
    fsType = "vfat";
    options = [ "umask=0077" "shortname=winnt" ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
