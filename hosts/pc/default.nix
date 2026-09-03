{pkgs, userName, hostName, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../profiles/system/core
    ../../profiles/system/hardware/nvidia.nix
    ../../profiles/system/gui
    ../../profiles/system/apps/common.nix
    ../../profiles/system/apps/dev.nix
    ../../profiles/system/apps/gamedev.nix
    ../../profiles/system/apps/gaming.nix
    ../../profiles/system/apps/streaming.nix
    ../../profiles/system/apps/desktop-extra.nix
  ];

  home-manager.users.userName = {
    imports = [
      ../../profiles/user/core.nix
    ];
  }

  networking.hostName = hostName;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # don't change!
  system.stateVersion = "25.11";
}
