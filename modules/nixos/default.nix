{ ... }: {
  imports = [
    ./login
    ./system
    ./nvidia
    ./steam
    ./bypass
    ./logitech
  ];

  programs.niri.enable = true;
}
