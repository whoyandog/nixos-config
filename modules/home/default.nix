{ ... }: {
  imports = [ 
    ./cursor
    ./kitty
    ./niri
    ./git
    ./waybar
    ./mpris-mqtt-adapter
    
    ./dbox-browser.nix
  ];
}
