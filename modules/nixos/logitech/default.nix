{ ... }: {
  imports = [
    ./wireless.nix
    ./g733-udev.nix
    ./led-init.nix
  ];
}