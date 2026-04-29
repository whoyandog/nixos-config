{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bind
    wlvncc
    mosquitto
    sing-box
    proxychains-ng
  ];
}
