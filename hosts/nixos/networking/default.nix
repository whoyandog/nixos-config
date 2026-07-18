{ config, pkgs, ... }:
{
  imports = [
    ./secrets.nix
    ./zapret.nix
    ./throne.nix
  ];

  networking.nftables.enable = true;
  networking.networkmanager.enable = true;
  
  services.tg-ws-proxy.enable = true;

  local.networking.n8n.enable = false;

}
