{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  services = {
    resolved = {
      #enable = true;
      dnssec = "false";
      fallbackDns = [
        "2606:4700:4700::1111"
        "2001:4860:4860::8888"
        "1.1.1.1"
        "8.8.8.8"
      ];
      llmnr = "false";
      extraConfig = ''
        Cache=yes
        CacheFromLocalhost=no
        DNSStubListener=yes
        ReadEtcHosts=yes
        ResolveUnicastSingleLabel=no
        DNSDefaultRoute=yes
        MulticastDNS=no
      '';
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
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "cgroups"
      "pipe-operator"
    ];
  };

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
          email = "marie0@riseup.net";
        };
      };
    };
  };

  system.activationScripts = {
    nixos-needsreboot = {
      supportsDryActivation = true;
      text = "${
        lib.getExe inputs.nixos-needsreboot.packages.${pkgs.system}.default
      } \"$systemConfig\" || true";
    };
  };

  nixpkgs.config.allowUnfree = true;
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";

  nixpkgs.overlays = [
    (final: prev: {
      inherit (prev.lixPackageSets.stable)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        ;
    })
  ];

  nix.package = pkgs.lixPackageSets.stable.lix;
}
