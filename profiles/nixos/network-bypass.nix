{pkgs, ...}: {
  # DPI bypass / proxy tooling shared between desktop and tablet.
  imports = [
    ../../modules/nixos/networking/zapret.nix
    ../../modules/nixos/networking/sing-box.nix
    ../../modules/nixos/networking/proxychains.nix
  ];

  environment.systemPackages = with pkgs; [
    sing-box
    proxychains-ng
  ];
}
