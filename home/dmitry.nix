# /etc/nixos/dmitry.nix
{ ... }: {
  home.username = "dmitry";
  home.homeDirectory = "/home/dmitry";
  home.stateVersion = "25.11";

  imports = [
    ../profiles/home
    ../modules/home
  ];

  programs.home-manager.enable = true;
}
