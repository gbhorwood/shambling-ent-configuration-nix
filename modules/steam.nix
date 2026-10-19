{ ... }:
{
  flake.modules.nixos.steam = { pkgs, ... }: {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;          # optional
      dedicatedServer.openFirewall = false;    # optional
      gamescopeSession.enable = false;         # optional: Steam-Deck-style session
    };

    # 32-bit graphics libraries, which most games need
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    unfreePackages = [ "steam" "steam-unwrapped" "steam-run" ];
  };
}
