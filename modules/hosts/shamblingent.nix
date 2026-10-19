{ inputs, config, ... }:
{
  flake.nixosConfigurations.shamblingent = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ../../configuration.nix
      config.flake.modules.nixos.unfree
      config.flake.modules.nixos.home-manager
      config.flake.modules.nixos.fish
      config.flake.modules.nixos.steam
      config.flake.modules.nixos.discord
      config.flake.modules.nixos.php-fpm
      config.flake.modules.nixos.nginx
      config.flake.modules.nixos.mysql
      config.flake.modules.nixos.site-orders-perfectfitclosets-ca
    ];
  };
}
