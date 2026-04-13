{ pkgs, ... }:
let
  dboxBrowserInit = pkgs.writeShellScriptBin "dbox-browser-init" ''
    set -euo pipefail

    CONTAINER_NAME="''${1:-browserbox}"
    IMAGE="''${2:-docker.io/library/ubuntu:24.04}"

    if ! command -v distrobox >/dev/null 2>&1; then
      echo "distrobox is not installed" >&2
      exit 1
    fi

    if distrobox list --no-color | awk 'NR>1 { print $1 }' | grep -Fxq "$CONTAINER_NAME"; then
      echo "Container '$CONTAINER_NAME' already exists."
    else
      echo "Creating container '$CONTAINER_NAME' from '$IMAGE'..."
      distrobox create --name "$CONTAINER_NAME" --image "$IMAGE" --yes
    fi

    echo "Installing base packages inside '$CONTAINER_NAME'..."
    distrobox enter "$CONTAINER_NAME" -- sh -lc '
      set -e
      export DEBIAN_FRONTEND=noninteractive
      sudo apt-get update
      sudo apt-get install -y \
        ca-certificates \
        curl \
        wget \
        gnupg \
        xdg-utils \
        libnss3-tools
      sudo update-ca-certificates
    '

    echo "Container is ready: $CONTAINER_NAME"
  '';

  yandexCorporate = pkgs.writeShellScriptBin "yandex-browser-corporate" ''
    set -euo pipefail
    exec "${pkgs.distrobox}/bin/distrobox-enter" -n browserbox -- \
      /usr/bin/yandex-browser-corporate \
      --ozone-platform=wayland \
      --enable-features=UseOzonePlatform \
      "$@"
  '';
in
{
  home.packages = with pkgs; [
    distrobox
    dboxBrowserInit
    yandexCorporate
  ];
}
