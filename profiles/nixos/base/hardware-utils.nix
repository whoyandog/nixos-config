{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    usbutils
    ntfs3g
  ];
}
