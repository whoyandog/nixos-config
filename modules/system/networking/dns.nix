{
  config,
  lib,
  ...
}: let
  cfg = config.local.networking.splitDns;

  mkServerRules = dnsIp: domains:
    map (domain: "/${lib.removePrefix "full:" domain}/${dnsIp}") domains;
in {
  options.local.networking.splitDns = {
    enable = lib.mkEnableOption "Split-DNS routing via dnsmasq";

    servers = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = {};
      example = {
        "108.160.138.51" = [
          "gemini.google.com"
          "aistudio.google.com"
        ];
      };
      description = ''
        Attribute set mapping upstream DNS server IPs to a list of domains
        that should be resolved through them. All other domains will use
        the default DHCP DNS from the router.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.dnsmasq = {
      enable = true;
      resolveLocalQueries = true;

      settings = {
        listen-address = [
          "127.0.0.1"
          "::1"
        ];
        bind-interfaces = true;

        server = lib.concatLists (
          lib.mapAttrsToList mkServerRules cfg.servers
        );
      };
    };
  };
}
