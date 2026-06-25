{ config, pkgs, ... }:

let
  fake = "${pkgs.zapret}/usr/share/zapret/files/fake";
  discordList = pkgs.writeText "zapret-discord-list" ''
    discord.com
    discordapp.com
    discordapp.net
    discord.gg
    discord.media
    gateway.discord.gg
    cdn.discordapp.com
    media.discordapp.net
  '';
  googleList = pkgs.writeText "zapret-google-list" ''
    yt3.ggpht.com
    yt4.ggpht.com
    yt3.googleusercontent.com
    googlevideo.com
    jnn-pa.googleapis.com
    wide-youtube.l.google.com
    youtube-nocookie.com
    youtube-ui.l.google.com
    youtube.com
    youtubeembeddedplayer.googleapis.com
    youtubekids.com
    youtubei.googleapis.com
    youtu.be
    yt-video-upload.l.google.com
    ytimg.com
    ytimg.l.google.com
    play.google.com
    stable.dl2.discordapp.net
  '';
  # Сервисы использующие TLS 1.3 — стратегия fake+ttl=3+tls-mod
  tls13List = pkgs.writeText "zapret-tls13-list" ''
    cache.nixos.org
    channels.nixos.org
    releases.nixos.org
  '';
in
{
  local.networking.zapret = {
    enable = true;
    # Стратегии подобраны blockcheck под провайдера.
    # TLS1.2 (Discord): hostfakesplit+ttl=3
    # TLS1.3 (YouTube, nixos cache): fake+ttl=3+tls-mod
    # QUIC (YouTube UDP): fake repeats=5
    args = [
      # 1. QUIC YouTube (UDP 443) — работает по blockcheck
      "--filter-udp=443"
      "--hostlist=${googleList}"
      "--dpi-desync=fake"
      "--dpi-desync-repeats=5"
      "--dpi-desync-fake-quic=${fake}/quic_initial_www_google_com.bin"
      "--new"
      # 2. Discord UDP (голос/видео/screen share)
      "--filter-udp=19294-19344,50000-50100"
      "--filter-l7=discord,stun"
      "--dpi-desync=fake"
      "--dpi-desync-repeats=6"
      "--dpi-desync-fake-discord=${../../../files/fake/quic_initial_dbankcloud_ru.bin}"
      "--dpi-desync-fake-stun=${../../../files/fake/quic_initial_dbankcloud_ru.bin}"
      "--new"
      # 3. Discord media TCP (альт. HTTPS порты)
      "--filter-tcp=2053,2083,2087,2096,8443"
      "--hostlist=${discordList}"
      "--dpi-desync=fake"
      "--dpi-desync-ttl=3"
      "--dpi-desync-fake-tls-mod=rnd,dupsid,rndsni,padencap"
      "--new"
      # 4. YouTube TCP 443 — TLS1.3, fake+ttl=3+tls-mod + ip-id=zero
      "--filter-tcp=443"
      "--hostlist=${googleList}"
      "--ip-id=zero"
      "--dpi-desync=fake"
      "--dpi-desync-ttl=3"
      "--dpi-desync-fake-tls-mod=rnd,dupsid,rndsni,padencap"
      "--new"
      # 5. Discord TCP 80+443
      "--filter-tcp=80,443"
      "--hostlist=${discordList}"
      "--dpi-desync=fake"
      "--dpi-desync-ttl=3"
      "--dpi-desync-fake-tls-mod=rnd,dupsid,rndsni,padencap"
      "--new"
      # 6. NixOS cache и другие TLS1.3 сервисы
      "--filter-tcp=443"
      "--hostlist=${tls13List}"
      "--dpi-desync=fake"
      "--dpi-desync-ttl=3"
      "--dpi-desync-fake-tls-mod=rnd,dupsid,rndsni,padencap"
    ];
  };
}
