{ ... }: {
  imports = [
    ./login
    ./system
    ./stylix
    ./nvidia
    ./steam
    ./bypass
    ./logitech
  ];

  programs.niri.enable = true;
}
