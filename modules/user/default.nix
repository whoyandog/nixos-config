{...}: {
  imports = [
    ./apps/cursor
    ./apps/kitty
    ./apps/thunar
    ./apps/opencode
    ./apps/dbox-browser.nix
    ./cli/neovim
    ./cli/git
    ./desktop/waybar
    ./desktop/niri
    ./services/mpris-mqtt-adapter
  ];
}
