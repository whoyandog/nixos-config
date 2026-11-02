{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication {
  pname = "tg-ws-proxy";
  version = "1.11.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Flowseal";
    repo = "tg-ws-proxy";
    rev = "v1.11.4";
    hash = "sha256-N7k8D2tnO4iVFq5lXjhdKpYMR+gDsCkKZLTpACpJStY=";
  };

  build-system = with python3.pkgs; [hatchling];

  dependencies = with python3.pkgs; [
    certifi
    cryptography
    h2
    httpx
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
