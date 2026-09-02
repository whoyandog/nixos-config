{
  config,
  pkgs,
  ...
}: {
  networking.nftables.enable = true;

  # throne 
  programs.throne.enable = true;
  programs.throne.tunMode.enable = true;

  services.tg-ws-proxy.enable = true;

  local.networking.n8n.enable = false;

  networking.firewall.allowedTCPPorts = [5173 8765];
}
