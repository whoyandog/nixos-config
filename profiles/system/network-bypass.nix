{pkgs, ...}: {
  # DPI bypass / proxy tooling shared between desktop and tablet.
  imports = [
    ../../modules/system/networking/zapret.nix
    ../../modules/system/networking/sing-box.nix
    ../../modules/system/networking/proxychains.nix
  ];

  environment.systemPackages = with pkgs; [
    sing-box
    proxychains-ng
  ];
}
