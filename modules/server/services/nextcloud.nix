{
  config,
  pkgs,
  lib,
  ...
}: let
  compDevices = ["laptop" "server"];
  device = config.core.device;

  mkIf = lib.mkIf;
  domain = "jswdev.nl";
in {
  services = mkIf (builtins.elem device compDevices) {
    # TODO: Declerative app install
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud27;
      hostName = domain;
      home = "/srv/nextcloud";
      enableImagemagick = true;
      autoUpdateApps = {
        enable = true;
        startAt = "08:00";
      };
      maxUploadSize = "12G";
      database.createLocally = true;
      configureRedis = true;
      config = {
        dbtype = "mysql";
        overwriteProtocol = "http"; # Temp solution till full hosting on tunnels
        extraTrustedDomains = [
          "https://${domain}"
          "http://localhost"
        ];
        trustedProxies = [
          "https://${domain}"
        ];
        adminuser = "jsw";
        adminpassFile = config.age.secrets.nextcloud.path;
        defaultPhoneRegion = "NL";
      };
      phpOptions = {
        "opcache.validate_timestamps" = "0";
        "opcache.jit" = "1255";
        "opcache.jit.buffer_size" = "512M";
        "opcache.interned_strings_buffer" = "32";
        "memory_limit" = "2G";
        "loglevel" = "2";
        "debug" = "false";
      };
      poolSettings = {
        # https://spot13.com/pmcalculator/; you can look in htop for the process size
        #"pm" = "static";
        pm = "static";
        "pm.max_children" = "84";
        "pm.start_servers" = "21";
        "pm.min_spare_servers" = "21";
        "pm.max_spare_servers" = "63";
      };
      nginx.recommendedHttpHeaders = true;
      https = false;
    };
  };
}
