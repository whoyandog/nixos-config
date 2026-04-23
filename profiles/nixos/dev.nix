{ pkgs, ... }:
let
  vscodeWithDesktopIcon = pkgs.vscode.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      substituteInPlace "$out/share/applications/code.desktop" \
        --replace-fail 'Icon=vscode' "Icon=$out/share/pixmaps/vscode.png"

      substituteInPlace "$out/share/applications/code-url-handler.desktop" \
        --replace-fail 'Icon=vscode' "Icon=$out/share/pixmaps/vscode.png"
    '';
  });
in {
  environment.systemPackages = [
    vscodeWithDesktopIcon
  ];
}
