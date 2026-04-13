{ pkgs, ... }: {
  imports = [
    ./system
    ./desktop
    ./programming
  ];
}
