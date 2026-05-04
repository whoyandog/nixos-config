{ ... }: {
  imports = [ 
    ./cursor
    ./kitty
    ./neovim
    ./niri
    ./git
    ./waybar
    ./mpris-mqtt-adapter
    
    ./dbox-browser.nix
  ];
}
