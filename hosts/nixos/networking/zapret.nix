{ config, lib, pkgs, ... }:

let
  fake = "${pkgs.zapret}/usr/share/zapret/files/fake";
  wl = "${config.local.networking.zapret.whitelistFile}";
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
in
{
  local.networking.zapret = {
    enable = true;
    whitelist = lib.mkOptionDefault [
      "theoutlasttrials.com"
      "steamserver.net"
      "compute-1.amazonaws.com"
      "amazonaws.com"
      "cloudfront.net"
      "steampowered.com"
      "epicgames.com"
      "ol.epicgames.com"
      "epicgames.dev"
    ];
    # Стратегия из kartavkun/general(ALT), адаптирована для nftables.
    args = [
      # 1. QUIC YouTube (UDP 443)
      "--filter-udp=443"
      "--hostlist=${wl}"
      "--dpi-desync=fake"
      "--dpi-desync-repeats=6"
      "--dpi-desync-fake-quic=${fake}/quic_initial_www_google_com.bin"
      "--new"
      # 2. Discord UDP (голос/видео)
      "--filter-udp=19294-19344,50000-50100"
      "--filter-l7=discord,stun"
      "--dpi-desync=fake"
      "--dpi-desync-fake-discord=${fake}/quic_initial_www_google_com.bin"
      "--dpi-desync-fake-stun=${fake}/quic_initial_www_google_com.bin"
      "--dpi-desync-repeats=6"
      "--new"
      # 3. Discord media (альт. HTTPS порты)
      "--filter-tcp=2053,2083,2087,2096,8443"
      "--hostlist-domains=discord.media"
      "--dpi-desync=fake,fakedsplit"
      "--dpi-desync-repeats=6"
      "--dpi-desync-fooling=ts"
      "--dpi-desync-fakedsplit-pattern=0x00"
      "--dpi-desync-fake-tls=${fake}/tls_clienthello_www_google_com.bin"
      "--new"
      # 4. Google/YouTube TCP — специальная секция с --ip-id=zero
      "--filter-tcp=443"
      "--hostlist=${googleList}"
      "--ip-id=zero"
      "--dpi-desync=fake,fakedsplit"
      "--dpi-desync-repeats=6"
      "--dpi-desync-fooling=ts"
      "--dpi-desync-fakedsplit-pattern=0x00"
      "--dpi-desync-fake-tls=${fake}/tls_clienthello_www_google_com.bin"
      "--new"
      # 5. EOS/Epic (Outlast Trials): QUIC
      "--filter-udp=443"
      "--hostlist-domains=theoutlasttrials.com,steamserver.net,compute-1.amazonaws.com,amazonaws.com,cloudfront.net,steampowered.com,epicgames.dev,epicgames.com,ol.epicgames.com"
      "--dpi-desync=fake"
      "--dpi-desync-repeats=11"
      "--dpi-desync-fake-quic=${fake}/quic_initial_www_google_com.bin"
      "--new"
      # 6. EOS/Epic (Outlast Trials): TLS
      "--filter-tcp=443"
      "--hostlist-domains=theoutlasttrials.com,steamserver.net,compute-1.amazonaws.com,amazonaws.com,cloudfront.net,steampowered.com,epicgames.dev,epicgames.com,ol.epicgames.com"
      "--ip-id=zero"
      "--dpi-desync=fake,fakedsplit"
      "--dpi-desync-repeats=8"
      "--dpi-desync-fooling=ts"
      "--dpi-desync-fakedsplit-pattern=0x00"
      "--dpi-desync-fake-tls=${fake}/tls_clienthello_www_google_com.bin"
      "--new"
      # 7. Игровой UDP (Steam/EOS matchmaking)
      "--filter-udp=3478-3479,4379-4380,7777-7780,27000-27100"
      "--dpi-desync=fake"
      "--dpi-desync-repeats=6"
      "--dpi-desync-fake-quic=${fake}/quic_initial_www_google_com.bin"
      "--new"
      # 8. Общий TCP 80+443 (Discord + остальное)
      "--filter-tcp=80,443"
      "--hostlist=${wl}"
      "--dpi-desync=fake,fakedsplit"
      "--dpi-desync-repeats=6"
      "--dpi-desync-fooling=ts"
      "--dpi-desync-fakedsplit-pattern=0x00"
      "--dpi-desync-fake-tls=${fake}/tls_clienthello_www_google_com.bin"
    ];
  };
}
