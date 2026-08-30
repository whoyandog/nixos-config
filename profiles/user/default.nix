# /etc/nixos/user.nix
{ userName, hostName, ...}: {
  home.username = userName;
  home.homeDirectory = "/home/${userName}";
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
    projects = "$HOME/projects";
    publicShare = "$HOME/public";
    templates = "$HOME/templates";
    videos = "$HOME/videos";
  };

  stylix.targets.qt.enable = false;
  stylix.targets.kde.enable = false;

  imports = [
    ./${hostName}.nix
    ../../modules/user
  ];

  programs.home-manager.enable = true;
}
