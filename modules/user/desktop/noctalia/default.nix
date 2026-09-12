{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.noctalia.packages.${pkgs.system}.default
  ];

  systemd.user.services.noctalia = {
    Unit = {
      Description = "Noctalia Desktop Shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}