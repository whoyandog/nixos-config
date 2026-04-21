{ pkgs, ... }:
let
  code = pkgs.writeShellScriptBin "code" ''
    exec "${pkgs.vscode}/bin/code" --password-store=gnome-libsecret "$@"
  '';
in
{
  home.packages = [
    code
  ];
}
