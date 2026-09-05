{...}: {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./portals.nix
    ./services.nix
    ./wm-tools.nix
    ../../../modules/system/ui/login
    ../../../modules/system/ui/stylix
  ];

  programs.niri.enable = true;
}
