{
  pkgs,
  inputs,
  ...
}: {
  # Shared "core work" applications available on every GUI host
  # (desktop, tablet), so work can continue seamlessly on either machine.
  environment.systemPackages = with pkgs; [
    kitty
    fuzzel
    wl-clipboard

    # browser
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # notes
    obsidian

    # messenger
    telegram-desktop
  ];
}
