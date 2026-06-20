{ lib
, python3
, fetchFromGitHub
}:

let
  python = python3.withPackages (ps: with ps; [
    cryptography
    psutil
    pyperclip
  ]);
in
python3.pkgs.buildPythonApplication {
  pname = "tg-ws-proxy";
  version = "1.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Flowseal";
    repo = "tg-ws-proxy";
    rev = "v1.7.3";
    hash = "sha256-b9Dmh41PEC3LZDhaSILUDrLApDgP0IiKXn//cvLfm9o=";
  };

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    cryptography
    psutil
    pyperclip
  ];

  doCheck = false;

  pythonRelaxDeps = true;
  pythonRemoveTestsDirHook = true;

  dontCheckRuntimeDeps = true;

  postInstall = ''
    rm -f $out/bin/tg-ws-proxy-tray-win
    rm -f $out/bin/tg-ws-proxy-tray-macos
    rm -f $out/bin/tg-ws-proxy-tray-linux
  '';

  meta = {
    description = "Local MTProto proxy server for Telegram via WebSocket";
    homepage = "https://github.com/Flowseal/tg-ws-proxy";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "tg-ws-proxy";
  };
}
