{ pkgs, ... }:
{
  # Printing via CUPS
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr ];
  };

  # Scanning via SANE (epson2 backend is included in sane-backends)
  hardware.sane.enable = true;

  # Add user to scanner and lp groups
  users.users.dmitry.extraGroups = [ "scanner" "lp" ];

  environment.systemPackages = with pkgs; [
    simple-scan
  ];
}
