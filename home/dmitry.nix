# /etc/nixos/dmitry.nix
{ ... }: {
  home.username = "dmitry";
  home.homeDirectory = "/home/dmitry";
  home.stateVersion = "25.11";

  stylix.targets.qt.enable = false;
  stylix.targets.kde.enable = false;

  imports = [
    ../profiles/home
    ../modules/home
  ];

  programs.home-manager.enable = true;
}
