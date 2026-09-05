{pkgs, inputs, ...}: {
    environment.systemPackages = with pkgs; [
        qutebrowser
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}