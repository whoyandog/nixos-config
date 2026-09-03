{...}: {
  imports = [
    ./fonts.nix
    ./portals.nix
    ./service.nix
    ./audio.nix
    ../../../modules/system/ui/login
    ../../../modules/system/ui/stylix
  ];

  programs.niri.enable = true;
}
