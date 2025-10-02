{
  pkgs,
  ...
}:
{
  services = {
    resolved = {
      enable = true;
      dnssec = "false";
      fallbackDns = [
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
        "1.1.1.1"
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
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse = {
        enable = true;
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
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services.openssh.enable = true;

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

  nixpkgs.config.allowUnfree = true;
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
}
