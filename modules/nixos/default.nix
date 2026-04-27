{ ... }: {
  imports = [
    ./login
    ./system
    ./stylix
    ./nvidia
    ./steam
    ./networking
    ./logitech
  ];

  programs.niri.enable = true;
}
