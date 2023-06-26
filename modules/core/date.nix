{config, ...}: let
  locale = "nl_NL.UTF-8";
  language = "en_US.UTF-8";
in {
  time.timeZone = "Europe/Amsterdam";
  i18n = {
    defaultLocale = language;
    extraLocaleSettings = {
      LC_ADDRESS = locale;
      LC_NAME = locale;
      LC_MONETARY = locale;
      LC_PAPER = locale;
      LC_IDENTIFICATION = locale;
      LC_TELEPHONE = locale;
      LC_MEASUREMENT = locale;
      LC_TIME = locale;
      LC_NUMERIC = locale;
      LANG = language;
    };
  };
}
