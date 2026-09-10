{pkgs, userName, hostName, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../profiles/system/core
    ../../profiles/system/gui

    ../../profiles/system/user-account.nix

    ../../profiles/system/networking/network-manager.nix
    ../../profiles/system/networking/nftables.nix
    ../../profiles/system/networking/dev-ports.nix

    # ../../profiles/system/network-bypass/zapret.nix
    # ../../profiles/system/network-bypass/tg-ws-proxy.nix

    ../../profiles/system/hardware/nvidia.nix
    ../../profiles/system/hardware/logitech.nix
    ../../profiles/system/hardware/printing.nix
    
    ../../profiles/system/apps/browsers.nix
    ../../profiles/system/apps/comminications.nix
    ../../profiles/system/apps/creative.nix
    ../../profiles/system/apps/dev.nix
    ../../profiles/system/apps/gaming.nix
    ../../profiles/system/apps/media.nix
    ../../profiles/system/apps/office.nix
    ../../profiles/system/apps/streaming.nix
  ];

  networking.hostName = hostName;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # don't change!
  system.stateVersion = "25.11";
}
