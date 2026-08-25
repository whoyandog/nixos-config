{
  config,
  pkgs,
  lib,
  ...
}:
# iPhone as low-latency camera for motion capture
#
# Two connection modes — pick one:
#
# ── MODE A: USB (recommended, lower latency) ──────────────────────────────────
#   1. iPhone → Настройки → Режим модема → включить (USB tethering)
#   2. Подключить iPhone по USB → при первом подключении тапнуть "Trust" на iPhone
#   3. ПК получит IP ~172.20.10.2, iPhone будет на 172.20.10.1
#   4. В Larix: srt://172.20.10.2:4000  latency: 20
#   5. Запустить ffmpeg (см. ниже) — указать IP 172.20.10.2 или 0.0.0.0
#
#   Узнать IP USB-интерфейса:
#     ip addr show | grep 172.20
#
# ── MODE B: Wi-Fi ─────────────────────────────────────────────────────────────
#   В Larix: srt://192.168.X.X:4000  (IP ПК в локальной сети)
#   ip route get 1 | awk '{print $7; exit}'
#
# ── ffmpeg команда (одинакова для обоих режимов) ─────────────────────────────
#   ffmpeg -fflags nobuffer -flags low_delay -analyzeduration 0 -probesize 32 \
#     -i "srt://0.0.0.0:4000?mode=listener&latency=20000" \
#     -vcodec rawvideo -pix_fmt yuv420p -f v4l2 /dev/video2
#
# ── Использование в Python / MediaPipe ───────────────────────────────────────
#   import cv2
#   cap = cv2.VideoCapture('/dev/video2')
#
# iPhone app: "Larix Broadcaster" (App Store, free)
#   Settings → Video: 720p, 30fps, 2000 kbps
#   Settings → Connections → +: srt://IP:4000  latency: 20
{
  # ── USB tethering support ─────────────────────────────────────────────────
  # ipheth — iPhone USB Ethernet kernel driver
  boot.kernelModules = ["ipheth"];

  # usbmuxd — required for initial iPhone trust over USB
  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  environment.systemPackages = with pkgs; [
    ffmpeg
    libimobiledevice # provides idevicepair (run once: sudo idevicepair pair)
  ];

  # ── Virtual camera device ─────────────────────────────────────────────────
  # mkForce overrides the OBS single-device line — creates both devices:
  #   /dev/video1 → OBS Cam   (programs.obs-studio.enableVirtualCamera)
  #   /dev/video2 → iPhone Camera (ffmpeg SRT pipeline)
  boot.extraModprobeConfig = lib.mkForce ''
    options v4l2loopback devices=2 video_nr=1,2 card_label="OBS Cam,iPhone Camera" exclusive_caps=1
  '';

  # ── Firewall ──────────────────────────────────────────────────────────────
  networking.firewall.allowedUDPPorts = [4000];

  # ── UDP socket buffers for SRT ────────────────────────────────────────────
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 134217728;
    "net.core.wmem_max" = 134217728;
    "net.core.rmem_default" = 33554432;
    "net.core.wmem_default" = 33554432;
  };
}
