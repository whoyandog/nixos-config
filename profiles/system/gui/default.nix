{...}: {
  imports = [
    ./fonts.nix
    ./portals.nix
    ./services.nix
    ./audio.nix
    ../../../modules/system/ui/login
    ../../../modules/system/ui/stylix
  ];

  programs.niri.enable = true;
}
