{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        kitty
        fuzzel
        wl-clipboard
    ];
}