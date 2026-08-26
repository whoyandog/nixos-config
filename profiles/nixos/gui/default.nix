{...}: {
  # Shared desktop-environment layer for hosts with a screen (desktop, tablet).
  # Not imported on server.
  imports = [
    ./fonts.nix
    ./portals.nix
    ./system.nix
    ../../../modules/nixos/login
    ../../../modules/nixos/stylix
  ];

  programs.niri.enable = true;
}
