{ ... }:
let
  mainBar = import ./settings/main-bar.nix;
  dockBar = import ./settings/dock-bar.nix;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = builtins.concatStringsSep "\n" [
      (builtins.readFile ./styles/base.css)
      (builtins.readFile ./styles/top-bar.css)
      (builtins.readFile ./styles/dock.css)
    ];

    settings = {
      inherit mainBar dockBar;
    };
  };
}
