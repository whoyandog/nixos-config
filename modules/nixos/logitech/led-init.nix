{ pkgs, ... }:
{
  systemd.services.logitech-g733-led-off = {
    description = "Disable Logitech G733 LEDs early in boot";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
    };

    script = ''
      ${pkgs.headsetcontrol}/bin/headsetcontrol -l 0 || true
      exit 0
    '';
  };
}