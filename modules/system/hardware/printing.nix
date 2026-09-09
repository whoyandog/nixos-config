{ pkgs, ... }: {
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr ];
  };
  
  hardware.sane.enable = true;
  users.users.dmitry.extraGroups = [ "scanner" "lp" ];

  environment.systemPackages = with pkgs; [
    simple-scan
  ];
}