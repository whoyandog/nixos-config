{...}: {
    environment.systemPackages = with pkgs; [
        krita
        godot_4
        libresprite
    ];
}