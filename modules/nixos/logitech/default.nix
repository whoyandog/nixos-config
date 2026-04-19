{ ... }: {
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true; 

  services.udev.extraRules = ''
    # Logitech G733 headset control access for active local user session.
    KERNEL=="hidraw*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0ab5", TAG+="uaccess", MODE="0660"
    KERNEL=="hidraw*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0ab6", TAG+="uaccess", MODE="0660"
  '';
}