{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        thunar
    ];
} 