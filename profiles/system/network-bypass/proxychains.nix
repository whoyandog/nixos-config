{ pkgs, ... }: 
{ 
    imports = [
        ../../../modules/system/networking/sing-box.nix
    ];

    environment.systemPackages = with pkgs; [
        proxychains-ng
    ];
}