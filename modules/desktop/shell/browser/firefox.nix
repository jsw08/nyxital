{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];
  shell = config.desktop.shell;
  username = config.core.username;

  mkIf = lib.mkIf;
  mkForce = lib.mkForce;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];
  config.home-manager.users.${username}.programs.firefox = mkIf (shell.browser == pkgs.firefox-bin && builtins.elem device compDevices) {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-esr-102-unwrapped {
      extraPolicies = {
        AutoAppUpdate = false;
        CaptivePortal = true;
        DisableFirefoxAccounts = true;
        DisableFormHistory = true;
        DisablePocket = true;
        DisableSetDesktopBackground = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = true;
        DisplayMenuBar = false;
        EnableTrackingProtection = true;
        EncryptedMediaExtensions = {
          Enabled = true;
          Locked = true;
        };
        OfferToSaveLogins = false;
        Containers.Default = [
          {
            name = "Personal";
            icon = "fingerprint";
            color = "orange";
          }
          {
            name = "School";
            icon = "briefcase";
            color = "blue";
          }
        ];
        ExtensionSettings = let
          mkForce = extensions:
            builtins.mapAttrs
            (name: cfg: {installation_mode = "force_installed";} // cfg)
            extensions;
        in
          mkForce {
            # Addon IDs are in manifest.json or manifest-firefox.json
            "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            "addon@darkreader.org".install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            "uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            "{74145f27-f039-47ce-a470-a662b129930a}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
            "{b86e4813-687a-43e6-ab65-0bde4ab75758}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/localcdn-fork-of-decentraleyes/latest.xpi";
            "DontFuckWithPaste@raim.ist".install_url = "https://addons.mozilla.org/firefox/downloads/latest/don-t-fuck-with-paste/latest.xpi";
            "{c607c8df-14a7-4f28-894f-29e8722976af}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/temporary-containers/latest.xpi";
            "skipredirect@sblask".install_url = "https://addons.mozilla.org/firefox/downloads/latest/skip-redirect/latest.xpi";
            "smart-referer@meh.paranoid.pk".install_url = "https://github.com/catppuccin/firefox/releases/download/old/smart-referer.xpi";
            "sponsorBlocker@ajay.app".install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            "7esoorv3@alefvanoon.anonaddy.me".install_url = "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";
          }; #TODO: Vimium C/FF
        Preferences = {
          "browser.toolbars.bookmarks.visibility" = "never";
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "toolkit.zoomManager.zoomValues" = ".8,.90,.95,1,1.1,1.2";
          "browser.uidensity" = 1;

          #TODO: "browser.startup.homepage" = "file://${./startpage.html}";
          "browser.uiCustomization.state" = ''
            {"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","addon_darkreader_org-browser-action","2_0_disconnect_me-browser-action","user-agent-switcher_ninetailed_ninja-browser-action","_884679b9-5d6b-48b2-90a7-15ae26ce568a_-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","downloads-button","unified-extensions-button","cors-everywhere_spenibus-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","ublock0_raymondhill_net-browser-action","_a6afa2be-9b78-4dba-9dda-d89e52b13b7d_-browser-action","_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["firefox-view-button","tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","ublock0_raymondhill_net-browser-action","addon_darkreader_org-browser-action","cors-everywhere_spenibus-browser-action","_a6afa2be-9b78-4dba-9dda-d89e52b13b7d_-browser-action","2_0_disconnect_me-browser-action","user-agent-switcher_ninetailed_ninja-browser-action","_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action","_884679b9-5d6b-48b2-90a7-15ae26ce568a_-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","unified-extensions-area","toolbar-menubar","TabsToolbar"],"currentVersion":19,"newElementCount":4}            '';

          "extensions.update.enabled" = false;
          "intl.locale.matchOS" = true;

          "media.eme.enabled" = true; #DRM
        };
      };
    };
  };
}
