{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bind
    wlvncc
    sing-box
    proxychains-ng
  ];
}
