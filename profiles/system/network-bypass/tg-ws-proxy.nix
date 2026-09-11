{ ... }: {
  imports = [
    ../../../modules/system/network-bypass/tg-ws-proxy.nix
  ];

  services.tg-ws-proxy.enable = true;
}