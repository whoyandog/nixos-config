# /etc/nixos/dmitry.nix
{ pkgs, ... }: {
  home.username = "dmitry";
  home.homeDirectory = "/home/dmitry";
  home.stateVersion = "25.11";

  imports = [
    ./modules/home-manager 
  ];

  programs.home-manager.enable = true;
}
