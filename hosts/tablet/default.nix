{pkgs, userName, hostName, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../../profiles/system/core
    ../../profiles/system/gui

    ../../profiles/system/user-account.nix

    ../../profiles/system/networking/network-manager.nix
    ../../profiles/system/networking/nftables.nix
    ../../profiles/system/networking/dev-ports.nix

    ../../profiles/system/network-bypass/zapret.nix
    ../../profiles/system/network-bypass/tg-ws-proxy.nix

    ../../profiles/system/virtualization/podman.nix

    ../../profiles/system/apps/browsers.nix
    ../../profiles/system/apps/comminications.nix
    ../../profiles/system/apps/dev.nix
    ../../profiles/system/apps/media.nix
  ];

  home-manager.users.${userName} = {
    imports = [
      ../../profiles/user/base.nix
      ../../profiles/user/core.nix
      ../../profiles/user/desktop.nix
      ../../profiles/user/dev.nix
    ];
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  networking.hostName = hostName;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # don't change!
  system.stateVersion = "25.11";
}