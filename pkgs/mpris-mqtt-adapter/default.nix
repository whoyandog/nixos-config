{ lib, rustPlatform, pkg-config, makeWrapper, playerctl }:

rustPlatform.buildRustPackage {
  pname = "mpris-mqtt-adapter";
  version = "0.1.0";

  src = ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
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
    description = "MPRIS/Playerctl to MQTT bridge with optional Home Assistant discovery";
    homepage = "https://local";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "mpris-mqtt-adapter";
  };
}
