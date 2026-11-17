{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    krita
    godot_4
    libresprite
    (blender.override { cudaSupport = true; })
  ];
}
