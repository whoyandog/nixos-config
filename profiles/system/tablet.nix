{...}: {
  imports = [
    ../../modules/system/steam
    ./gui
    ./apps-common.nix
    ./network-bypass.nix
  ];

  # NOTE: power-saving tuning (TLP/auto-cpufreq, animation slowdown, etc.)
  # is intentionally deferred until the machine is installed and can be
  # tested for real. See profiles/home/tablet.nix for app-level choices.
}
