{ config, ... }:
{
  flake.modules.nixos.site-orders-perfectfitclosets-ca = config.flake.lib.mkPhpSite {
    url = "orders.perfectfitclosets.test";
    project = "perfectfitclosets.ca";
    docroot = "/public";
    phpPool = "php83";
  };
}
