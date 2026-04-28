{ ... }: {
  services.udev.extraRules = ''
    # Logitech G733 headset control access for active local user session.
    KERNEL=="hidraw*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0ab5", TAG+="uaccess", MODE="0660"
    KERNEL=="hidraw*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0ab6", TAG+="uaccess", MODE="0660"

    # Re-apply LED-off state when headset appears after boot.
    ACTION=="add", SUBSYSTEM=="hidraw", ENV{ID_VENDOR_ID}=="046d", ENV{ID_MODEL_ID}=="0ab5", TAG+="systemd", ENV{SYSTEMD_WANTS}+="logitech-g733-led-off.service"
  '';
}
