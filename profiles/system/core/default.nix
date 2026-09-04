{config, ...}: {
  imports = [
    ./system-utils.nix
    ./hardware-utils.nix
    ./networking.nix
    ./security.nix
    ./locale.nix
    ./time.nix
    ./nix-settings.nix
  ];
}
