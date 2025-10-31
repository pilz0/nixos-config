{
  description = "PilzOS";
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.05";
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
  outputs =
    {
      self,
      nixpkgs,
      agenix,
      nixos-hardware,
      nixarr,
      home-manager,
      spicetify-nix,
      disko,
      harmonia,
      colmena,
      ...
    }@inputs:
    {
      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ ];
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
            };
          };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      packages.x86_64-linux =
        let
          pkgs = import nixpkgs { system = "x86_64-linux"; };
        in
        {
          pmacct-custom = pkgs.callPackage ./custom_pkgs/pmacct.nix {
            withKafka = true;
            withJansson = true;
            withPgSQL = true;
            withSQLite = true;
          };
          flow-exporter-custom = pkgs.callPackage ./custom_pkgs/flow-exporter.nix { };
        };
      nixosConfigurations = {
        "serva" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit self;
            inherit inputs;
            inherit nixarr;
            inherit agenix;

          };
          system = "x86_64-linux";
          modules = [
            ./machines/serva
            agenix.nixosModules.default
            nixarr.nixosModules.default
            {
              environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
            }
          ];
        };
        "grafana.ams1.as214958.net" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit self;
            inherit inputs;
            inherit agenix;
            flow-exporter-custom = self.packages.x86_64-linux.flow-exporter-custom;
          };
          system = "x86_64-linux";
          modules = [
            ./machines/grafana.ams1.as214958.net
            agenix.nixosModules.default
            disko.nixosModules.disko
            {
              environment.systemPackages = [
                self.packages.x86_64-linux.flow-exporter-custom
                agenix.packages.x86_64-linux.default
              ];
            }
          ];
        };
        "framwok" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit agenix;
            inherit inputs;
            inherit spicetify-nix;
          };
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            ./machines/framwok
            nixos-hardware.nixosModules.framework-12th-gen-intel
            home-manager.nixosModules.home-manager
            {
              environment.systemPackages = [
                agenix.packages.x86_64-linux.default
              ];
            }
          ];
        };
      };
    };
}
