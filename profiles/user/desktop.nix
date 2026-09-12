{ pkgs, ... }:

{
  imports = [
    ../../modules/user/apps/cursor
    ../../modules/user/apps/kitty
    ../../modules/user/apps/thunar
    ../../modules/user/apps/opencode
    ../../modules/user/apps/dbox-browser.nix
    ../../modules/user/cli/git
    ../../modules/user/cli/neovim
    ../../modules/user/desktop/niri
    ../../modules/user/desktop/noctalia
    ../../modules/user/services/mpris-mqtt-adapter
    ./mpris-mqtt-adapter.nix
  ];

  home.packages = [
    pkgs.awww
  ];
}