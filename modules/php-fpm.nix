{
  flake.modules.nixos.php-fpm = { config, pkgs, ... }:
    let
      ###
      # make php with extra extensions
      mkPhp = php: php.withExtensions ({ enabled, all }:
        enabled ++ (with all; [
          imagick
          mbstring
          bcmath
          mysqli
          gd
          pdo_mysql
        ]));

      mkPool = phpPackage: extraOptions: {
        inherit phpPackage;
        user = "ghorwood";
        group = "users";
        settings = {
            "listen.owner" = config.services.nginx.user;
            "listen.group" = config.services.nginx.group;
            "pm" = "ondemand";
            "pm.max_children" = 10;
            "pm.process_idle_timeout" = "30s";
            
            "php_admin_value[open_basedir]" = "/home/ghorwood/Projects:/tmp:/run/mysqld";
        };
        phpOptions = extraOptions;     # per-pool only

      };
    in {
      services.phpfpm.phpOptions = ''
        display_errors = Off
        log_errors = On
        error_reporting = E_ALL
        memory_limit = 512M
        upload_max_filesize = 200M
        post_max_size = 200M
        mysqli.default_socket = /run/mysqld/mysqld.sock # new
        pdo_mysql.default_socket = /run/mysqld/mysqld.sock # new
      '';

      services.phpfpm.pools.php83 = mkPool (mkPhp pkgs.php83) ''
        error_log = "/home/ghorwood/Projects/phperrors_83.log"
      '';
      services.phpfpm.pools.php85 = mkPool (mkPhp pkgs.php85) ''
        error_log = "/home/ghorwood/Projects/phperrors_85.log"
      '';
    };
}
