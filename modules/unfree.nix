{ ... }:
{
  flake.modules.nixos.unfree = { config, lib, ... }: {
    options.unfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    config.nixpkgs.config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) config.unfreePackages;
  };
}
