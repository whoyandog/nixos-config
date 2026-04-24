{ ... }: {
  imports = [ 
    ./cursor
    ./kitty
    ./niri
    ./git
    ./waybar
    ./mpris-mqtt-bridge
    
    ./dbox-browser.nix
  ];
}
