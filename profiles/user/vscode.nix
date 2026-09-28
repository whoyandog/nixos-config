{pkgs, ...}: let
  code = pkgs.writeShellScriptBin "code" ''
    exec "/run/current-system/sw/bin/code" --password-store=gnome-libsecret "$@"
  '';
in {
  home.packages = [
    code
  ];
}
