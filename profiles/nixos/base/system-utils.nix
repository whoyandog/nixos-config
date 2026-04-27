{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    git
    ouch
    screenfetch
    yazi
    thunar
  ];
}
