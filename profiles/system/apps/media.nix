{inputs, ...}: {
    environment.systemPackages = with pkgs; [
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.yandex-music.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}