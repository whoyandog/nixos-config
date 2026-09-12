{pkgs, ...}: {
    home.packages = with pkgs; [
        hmcl
        temurin-jre-bin-21
    ];
}