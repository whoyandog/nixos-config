{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    solaar
    headsetcontrol
  ];
}
