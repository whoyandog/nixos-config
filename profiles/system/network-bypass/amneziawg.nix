{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    amneziawg-tools 
    amneziawg-go 
  ];
}