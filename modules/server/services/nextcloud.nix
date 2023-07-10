{
  config,
  pkgs,
  lib,
  ...
}: let
  compDevices = ["laptop" "server"];
  device = config.core.device;

  mkIf = lib.mkIf;
  optAttrs = lib.optionalAttrs;

  devMode = true; #FIXME: disable devmode
  domain =
    if devMode
    then "localhost"
    else "cloud.jswdev.nl";
in {
  config = mkIf (builtins.elem device compDevices && true) {
    # FIXME: remove false
    # TODO: Add comments
    services = {
      nextcloud = {
        enable = true;
        package = pkgs.nextcloud27;
        home = "/srv/nextcloud";
        maxUploadSize = "12G";
        notify_push.enable = true;

        hostName = domain;
        autoUpdateApps = {
          enable = true;
          startAt = "08:00";
        };

        enableImagemagick = true;
        database.createLocally = true; # Automatically create config for pgsql
        configureRedis = true; # For za speeeeeed

        config = {
          dbtype = "pgsql";
          overwriteProtocol =
            # Else can't access on localhost
            if devMode
            then "http"
            else "https";
          extraTrustedDomains = [
            "https://${domain}"
            "192.168.1.111"
          ];
          trustedProxies = [
            "https://${domain}"
            "http://192.168.1.111"
          ];
          adminuser = "jsw";
          adminpassFile = config.age.secrets.nextcloud.path;
          defaultPhoneRegion = "NL";
        };
        phpOptions =
          {
            # For more speeeed
            "opcache.save_comments" = "1";
            "opcache.validate_timestamps" = "0";
            "opcache.jit" = "1255";
            "opcache.jit.buffer_size" = "512M";
            "opcache.interned_strings_buffer" = "32";
            "memory_limit" = "2G";
            "loglevel" = "2";
            "debug" = "false";
            "memcache.local" = "\OC\Memcache\APCu";
            "memcache.locking" = "\OC\Memcache\Redis";
            "memcache.distributed" = "\OC\Memcache\Redis";
            "enabledPreviewProviders" = "['OC\Preview\MP3','OC\Preview\TXT','OC\Preview\MarkDown','OC\Preview\OpenDocument','OC\Preview\Krita','OC\Preview\Imaginary']";
            "preview_imaginary_url" = "http://localhost:9010"; #FIXME:
          }
          // (optAttrs (!devMode) {
            "overwritehost" = domain;
            "overwriteprotocol" = "https";
            "overwritewebroot" = "/";
            "overwrite.cli.url" = "https://${domain}";
          });
        poolSettings = {
          # https://spot13.com/pmcalculator/; you can look in htop for the process size for me ~335mb
          "pm" = "static";
          "pm.max_children" = "84";
          "pm.start_servers" = "21";
          "pm.min_spare_servers" = "21";
          "pm.max_spare_servers" = "63";
        };
        caching = {
          apcu = true;
          redis = true;
        };
        nginx.recommendedHttpHeaders = true;
        https = !devMode;
      };
      nginx = {
        enable = true;
        virtualHosts = {
          "${domain}".listen = [
            {
              addr = "127.0.0.1";
              port = 9000;
            }
            {
              addr = "192.168.1.111";
              port = 80;
            }
          ];
        };
      };
      imaginary = {
        enable = true; #FIXME:
        port = 9010;
        settings = {
          #cpu = "4";
          return-size = true;
        }; # Won't run without a setting set for some reason.
      };
    };
    environment.systemPackages = [pkgs.pandoc];
    networking.firewall.allowedTCPPorts = [80];
  };
}
