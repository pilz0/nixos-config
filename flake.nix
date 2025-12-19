{
  description = "Pilz's nixos-based infra";
  outputs =
    {
      nixpkgs,
      agenix,
      nixos-hardware,
      nixarr,
      home-manager,
      disko,
      harmonia,
      ...
    }:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      colmena = {
        meta = {
          description = "Pilz's nixos-based infra";
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ ];
          };
        };
        "framwok" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              agenix.nixosModules.default
              ./machines/framwok
              nixos-hardware.nixosModules.framework-12th-gen-intel
              home-manager.nixosModules.home-manager
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "null";
              allowLocalDeployment = true;
            };
          };
        "serva" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/serva
              agenix.nixosModules.default
              nixarr.nixosModules.default
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "fff161.ddns.net";
              targetUser = "root";
              targetPort = 22;
            };
          };
        "netbox.ams1.as214958.net" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/netbox.ams1.as214958.net
              agenix.nixosModules.default
              disko.nixosModules.disko
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "netbox.ams1.as214958.net";
              targetUser = "root";
              targetPort = 22;
              tags = [
                "infra"
                "ams1"
              ];
            };
          };
        "dn42.ams1.as214958.net" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/dn42.ams1.as214958.net
              agenix.nixosModules.default
              disko.nixosModules.disko
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "dn42.ams1.as214958.net";
              targetUser = "root";
              targetPort = 22;
              tags = [
                "infra"
                "ams1"
              ];
            };
          };
        "web1.ams1.as214958.net" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/web1.ams1.as214958.net
              agenix.nixosModules.default
              disko.nixosModules.disko
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "web1.ams1.as214958.net";
              targetUser = "root";
              targetPort = 22;
              tags = [
                "infra"
                "ams1"
              ];
            };
          };
        "build.ams1.as214958.net" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/build.ams1.as214958.net
              agenix.nixosModules.default
              disko.nixosModules.disko
              harmonia.nixosModules.harmonia

            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "build.ams1.as214958.net";
              targetUser = "root";
              targetPort = 22;
              tags = [
                "infra"
                "ams1"
              ];
            };
          };
        "jellyfin.ams1.as214958.net" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/jellyfin.ams1.as214958.net
              agenix.nixosModules.default
              disko.nixosModules.disko
              nixarr.nixosModules.default
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "jellyfin.ams1.as214958.net";
              targetUser = "root";
              targetPort = 22;
              tags = [
                "infra"
                "ams1"
              ];
            };
          };
        "rpki.ams1.as214958.net" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/rpki.ams1.as214958.net
              agenix.nixosModules.default
              disko.nixosModules.disko
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "rpki.ams1.as214958.net";
              targetUser = "root";
              targetPort = 22;
              tags = [
                "infra"
                "ams1"
              ];
            };
          };
        "grafana.ams1.as214958.net" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/grafana.ams1.as214958.net
              agenix.nixosModules.default
              disko.nixosModules.disko
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "grafana.ams1.as214958.net";
              targetUser = "root";
              targetPort = 22;
              tags = [
                "infra"
                "ams1"
              ];
            };
          };
        "tor1.ams1.as214958.net" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/tor1.ams1.as214958.net
              agenix.nixosModules.default
              disko.nixosModules.disko
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "tor1.ams1.as214958.net";
              targetUser = "root";
              targetPort = 22;
              tags = [
                "tor"
                "ams1"
              ];
            };
          };
        "tor2.ams1.as214958.net" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/tor2.ams1.as214958.net
              agenix.nixosModules.default
              disko.nixosModules.disko
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "tor2.ams1.as214958.net";
              targetUser = "root";
              targetPort = 22;
              tags = [
                "tor"
                "ams1"
              ];
            };
          };
        "tor3.ams1.as214958.net" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/tor3.ams1.as214958.net
              agenix.nixosModules.default
              disko.nixosModules.disko
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "tor3.ams1.as214958.net";
              targetUser = "root";
              targetPort = 22;
              tags = [
                "tor"
                "ams1"
              ];
            };
          };
        "tor4.ams1.as214958.net" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/tor4.ams1.as214958.net
              agenix.nixosModules.default
              disko.nixosModules.disko
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "tor4.ams1.as214958.net";
              targetUser = "root";
              targetPort = 22;
              tags = [
                "tor"
                "ams1"
              ];
            };
          };
        "tor5.ams1.as214958.net" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/tor5.ams1.as214958.net
              agenix.nixosModules.default
              disko.nixosModules.disko
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "tor5.ams1.as214958.net";
              targetUser = "root";
              targetPort = 22;
              tags = [
                "tor"
                "ams1"
              ];
            };
          };
        "tor6.ams1.as214958.net" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/tor6.ams1.as214958.net
              agenix.nixosModules.default
              disko.nixosModules.disko
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "tor6.ams1.as214958.net";
              targetUser = "root";
              targetPort = 22;
              tags = [
                "tor"
                "ams1"
              ];
            };
          };
        "tor7.ams1.as214958.net" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/tor7.ams1.as214958.net
              agenix.nixosModules.default
              disko.nixosModules.disko
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "tor7.ams1.as214958.net";
              targetUser = "root";
              targetPort = 22;
              tags = [
                "tor"
                "ams1"
              ];
            };
          };
        "tor8.ams1.as214958.net" =
          {
            config,
            pkgs,
            inputs,
            ...
          }:
          {
            imports = [
              ./machines/tor8.ams1.as214958.net
              agenix.nixosModules.default
              disko.nixosModules.disko
            ];
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
            deployment = {
              targetHost = "tor8.ams1.as214958.net";
              targetUser = "root";
              targetPort = 22;
              tags = [
                "tor"
                "ams1"
              ];
            };
          };
      };
    };
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.11";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    agenix = {
      url = "github:ryantm/agenix";
    };
    nixarr = {
      url = "github:rasmus-kirk/nixarr";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    harmonia = {
      url = "github:nix-community/harmonia?ref=47d447dd3392dc97ea24d3368dfd84b14d2c5f09";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
