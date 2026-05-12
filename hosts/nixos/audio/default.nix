{ ... }:
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # Settings for better input 

    extraConfig.pipewire."10-clock" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 512;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 2048;
        "default.video.width" = 1920;
        "default.video.height" = 1080;
        "default.video.rate.num" = 60;
        "default.video.rate.denom" = 1;
      };
    };
  };
}
