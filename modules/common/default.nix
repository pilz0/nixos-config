{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  options.pilz.common.enable = lib.mkEnableOption "";
  config = lib.mkIf config.pilz.common.enable {

    nix.extraOptions = ''
      builders-use-substitutes = true
    '';
    nix.settings = {
      substituters = lib.mkAfter [
        "https://cache.nixos-cuda.org"
        "https://nix-community.cachix.org"
        "https://cache.lix.systems"
        "https://nixpkgs-update-cache.nix-community.org"
        "https://cache.kyouma.net"
      ];

      trusted-public-keys = lib.mkAfter [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "nixpkgs-update-cache.nix-community.org-1:U8d6wiQecHUPJFSqHN9GSSmNkmdiFW7GW7WNAnHW0SM="
        "cache.kyouma.net:Frjwu4q1rnwE/MnSTmX9yx86GNA/z3p/oElGvucLiZg="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
    };

    nix.settings.allowed-users = [ "@users" ];

    boot.tmp.cleanOnBoot = lib.mkDefault true;
    pilz.pkgs.default.enable = true;
    services = {
      resolved = {
        enable = lib.mkDefault true;
        settings.Resolve = {
          Cache = lib.mkDefault true;
          CacheFromLocalhost = "no";
          DNSStubListener = "yes";
          ReadEtcHosts = "yes";
          ResolveUnicastSingleLabel = "no";
          DNSDefaultRoute = "yes";
          MulticastDNS = "no";
          dnssec = "false";
          FallbackDNS = [
            "2606:4700:4700::1111"
            "2001:4860:4860::8888"
            "1.1.1.1"
            "8.8.8.8"
          ];
          llmnr = "false";
        };
      };
    };

    nix = {
      optimise = {
        automatic = true;
        randomizedDelaySec = "0";
        dates = [
          "03:45"
        ];
      };
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };
      settings = {
        trusted-users = [
          "root"
          "@wheel"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
          "cgroups"
          "pipe-operators"
        ];
      };
    };

    nixpkgs.config.allowUnfree = true;

    users.mutableUsers = lib.mkDefault false;

    security = {
      acme = {
        acceptTerms = true;
        defaults.email = "acme@pilz.foo";
      };
    };

    time = {
      timeZone = "Europe/Berlin";
    };
    i18n = {
      defaultLocale = "de_DE.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };
    };
    console = {
      keyMap = "de";
    };
    security = {
      rtkit = {
        enable = true;
      };
    };

    programs = {
      git = {
        config = {
          user = {
            name = "pilz0";
            email = "48645439+pilz0@users.noreply.github.com";
          };
        };
      };
    };

    system.activationScripts = {
      nixos-needsreboot = {
        supportsDryActivation = true;
        text = "${
          lib.getExe inputs.nixos-needsreboot.packages.${pkgs.stdenv.hostPlatform.system}.default
        } \"$systemConfig\" || true";
      };
    };
  };
}
