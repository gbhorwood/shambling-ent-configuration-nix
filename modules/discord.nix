{ ... }:
{
  flake.modules.nixos.discord = { pkgs, ... }: {
    unfreePackages = [ "discord" ];
    environment.systemPackages = [ pkgs.discord ];
  };
}
