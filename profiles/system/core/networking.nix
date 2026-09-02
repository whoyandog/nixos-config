{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bind
    wlvncc
  ];
}
