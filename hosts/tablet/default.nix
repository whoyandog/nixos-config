{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../profiles/nixos/tablet.nix
  ];

}