{inputs, ...}: {
    environment.systemPackages = with pkgs; [
        inputs.yandex-music.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}