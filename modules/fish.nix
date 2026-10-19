{
  flake.modules.nixos.fish = { pkgs, ... }: {
    programs.fish.enable = true;
  };

  flake.modules.homeManager.fish = {
    programs.fish = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        lR = "ls -laR";
      };
      interactiveShellInit = ''
        set -g fish_greeting
      '';
    };
  };

}
