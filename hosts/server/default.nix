{ ... }:

{
  imports =
    [ 
      # ./hardware-configuration.nix # Uncomment this when you generate hardware-configuration
      ../../modules/nixos/core/time.nix
      ../../modules/nixos/core/locale.nix
      ../../modules/nixos/core/users
      ../../modules/nixos/core/nix-settings.nix
      ../../profiles/nixos/base
    ];
}
