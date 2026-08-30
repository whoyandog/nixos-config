{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../profiles/system/tablet.nix
  ];
}