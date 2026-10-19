{ inputs, config, ... }:
{
  flake.modules.nixos.home-manager = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;          # reuse the system's nixpkgs (and unfree settings)
      useUserPackages = true;        # install user packages into the user profile
      backupFileExtension = "bak";   # move aside files that are in the way
    };

    home-manager.users.ghorwood = {
      home.stateVersion = "26.05";   # set once, leave alone
      imports = [
        config.flake.modules.homeManager.fish
      ];
    };
  };
}
