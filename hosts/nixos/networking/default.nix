{ ... }:
{
  imports = [
    ./secrets.nix
  ];

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  local.networking.n8n.enable = false;
}
