{ pkgs, ... }: {
  imports = [
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    gcc
    rustc
    cargo
    clippy
    rustfmt
    rust-analyzer
    podman-compose
    opencode
    antigravity-cli
  ];
}
