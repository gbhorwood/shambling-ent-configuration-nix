{ ... }:
{
  # nginx general config
  flake.modules.nixos.nginx = { lib, ... }: {
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      clientMaxBodySize = "200M";     # match upload_max_filesize in php.ini
    };

    # let nginx see /home (the default unit hides it)
    systemd.services.nginx.serviceConfig.ProtectHome = lib.mkForce "read-only";

    # let the nginx user traverse into /home/ghorwood (can't list it)
    users.users.ghorwood.homeMode = "711";

    networking.firewall.allowedTCPPorts = [ 80 ];
  };

  ###
  # Function to make virtual host for php site
  # param: url. The local url as registered in /etc/hosts
  # param: project. The name of the directory inside of Projects/
  # param: docroot. The directory inside the project to serve, ie. '/public' for laravel. requires a leading slash.
  # param: phpPool. The php fpm pool, ie "php83" or "php85"
  # returns a nixos module
  flake.lib.mkPhpSite =
    { url,
      project,
      docroot ? "",
      phpPool ? "php83"
    }:

    # validate correct php pools
    assert builtins.elem phpPool [ "php83" "php85" ];


    { config, pkgs, ... }: {
      networking.hosts."127.0.0.1" = [ url ];
      
      services.nginx.virtualHosts."${url}" = {
        root = "/home/ghorwood/Projects/${project}${docroot}";


        locations."/" = {
          index = "index.php index.html";
          tryFiles = "$uri $uri/ /index.php?$query_string";
        };

        locations."~ \\.php$".extraConfig = ''
          try_files $uri =404;
          fastcgi_pass unix:${config.services.phpfpm.pools.${phpPool}.socket};
          include ${pkgs.nginx}/conf/fastcgi.conf;
        '';
      };
    };
}
