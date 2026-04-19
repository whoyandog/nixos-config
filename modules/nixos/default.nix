{ ... }: {
  imports = [
    ./login
    ./nvidia
    ./steam
    ./bypass
    # ./logitech
  ];

  programs.niri.enable = true;
}
