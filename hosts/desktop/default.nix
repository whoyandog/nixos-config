{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../profiles/system/base
    ../../profiles/system/desktop
    ../../profiles/system/nix-settings.nix
    ../../profiles/system/dev.nix
    ../../profiles/system/gamedev.nix
  ];

  networking.hostName = "desktop";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # don't change!
  system.stateVersion = "25.11";
}
