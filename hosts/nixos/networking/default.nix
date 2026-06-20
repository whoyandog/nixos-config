{ ... }:
{
  imports = [
    ./secrets.nix
    ./zapret.nix
  ];

  networking.nftables.enable = true;
  networking.networkmanager.enable = true;
  
  services.tg-ws-proxy.enable = true;

  local.networking.n8n.enable = false;
}
