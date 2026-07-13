{ ... }:
{
  imports = [
    ./secrets.nix
    ./zapret.nix
  ];

  networking.nftables.enable = true;
  networking.networkmanager.enable = true;
  
  services.tg-ws-proxy.enable = false;

  local.networking.n8n.enable = false;

  # throne settings, mb i shoul put it in another file 
  programs.throne.enable = true;
  programs.throne.tunMode.enable = true;
}
