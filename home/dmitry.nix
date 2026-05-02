# /etc/nixos/dmitry.nix
{ ... }: {
  home.username = "dmitry";
  home.homeDirectory = "/home/dmitry";
  home.stateVersion = "25.11";

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = false;

    desktop = "$HOME/desktop";
    documents = "$HOME/documents";
    download = "$HOME/downloads";
    music = "$HOME/music";
    pictures = "$HOME/pictures";
    publicShare = "$HOME/public";
    templates = "$HOME/templates";
    videos = "$HOME/videos";
  };

  stylix.targets.qt.enable = false;
  stylix.targets.kde.enable = false;

  imports = [
    ../profiles/home
    ../modules/home
  ];

  programs.home-manager.enable = true;
}
