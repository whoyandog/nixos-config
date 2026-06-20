{ ... }: {
  imports = [
    ./login
    ./system
    ./stylix
    ./nvidia
    ./steam
    ./networking
    ./logitech
    ./tg-ws-proxy.nix
  ];

  programs.niri.enable = true;
}
