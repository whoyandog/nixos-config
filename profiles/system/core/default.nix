{config, ...}: {
  imports = [
    ./hardware-utils.nix
    ./locale.nix
    ./memory.nix
    ./networking.nix
    ./nix-settings.nix
    ./security.nix
    ./system-utils.nix
    ./time.nix
  ];
}
