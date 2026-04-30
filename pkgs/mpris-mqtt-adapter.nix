{ lib, rustPlatform, pkg-config, makeWrapper, playerctl, src }:

rustPlatform.buildRustPackage {
  pname = "mpris-mqtt-adapter";
  version = "unstable";

  inherit src;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  postInstall = ''
    wrapProgram "$out/bin/mpris-mqtt-adapter" \
      --prefix PATH : ${lib.makeBinPath [ playerctl ]}
  '';

  meta = with lib; {
    description = "MPRIS/Playerctl to MQTT adapter with optional Home Assistant discovery";
    homepage = "https://github.com/whoyandog/mpris-mqtt-adapter";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "mpris-mqtt-adapter";
  };
}
