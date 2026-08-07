# modified version of https://woof.rip/emily/nixfiles/src/branch/main/lib/shinyflakes/default.nix
{
  nixpkgs,
  nix-darwin,
  ...
}@inputs:
let
  inherit (nixpkgs) lib;
  inherit (builtins) mapAttrs;

  mergeWith = x: y: lib.recursiveUpdate y x;

  genColmenaCfg = name: host: {
    deployment = {
      allowLocalDeployment = host.config.pilz.deployment.allowLocalDeployment;
      buildOnTarget = host.config.pilz.deployment.buildOnTarget;
      targetHost = host.config.pilz.deployment.targetHost;
      targetPort = host.config.pilz.deployment.targetPort;
      targetUser = host.config.pilz.deployment.targetUser;
      tags = host.config.pilz.deployment.tags;
    };
    imports = host._module.args.modules;
    nixpkgs.system = host.config.nixpkgs.system;
  };

  genDarwinCfg =
    {
      hostname,
      system ? "aarch64-darwin",
    }:
    nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs;
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      modules = [
        ../../machines/darwin/${hostname}
        inputs.agenix.darwinModules.default
        inputs.home-manager.darwinModules.home-manager
        (
          { ... }:
          {
            nixpkgs.system = system;
          }
        )
      ];
    };
  genNixosCfg =
    {
      hostname,
      system ? "x86_64-linux",
      nixpkgs ? inputs.nixpkgs,
    }:
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ../deployment
        ../../machines/${hostname}
        inputs.agenix.nixosModules.default
        (
          { ... }:
          {
            # claude slop that needs to be cleaned
            nixpkgs.hostPlatform.system = system;
            # Provide pkgs-unstable via _module.args (not specialArgs) so it is
            # also available when colmena re-evaluates a node from its module
            # list -- colmena only forwards `inputs` via meta.specialArgs.
            _module.args.pkgs-unstable = import inputs.nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          }
        )
      ];
    };

  genTestCfg =
    {
      testname,
      pkgs,
    }:
    {
      ${testname} = pkgs.callPackage ../../tests/${testname}.nix { };
    };
in
{
  mapHostsMerge =
    hdir: extraCfg:
    builtins.readDir hdir
    |> lib.filterAttrs (n: t: t == "directory")
    |> lib.filterAttrs (name: _: !(lib.hasInfix "darwin" name))
    |> builtins.attrNames
    |> (
      dir:
      lib.genAttrs dir (host: {
        hostname = host;
      })
    )
    |> mergeWith extraCfg;

  mapColmenaMerge =
    nixosCfg: extraCfg:
    lib.filterAttrs (name: _: !(lib.hasInfix "darwin" name)) nixosCfg
    |> mapAttrs genColmenaCfg
    |> mergeWith extraCfg;

  mapDarwinCfg =
    {
      darwinHosts,
    }:
    mapAttrs (_: v: genDarwinCfg v) darwinHosts;

  mapNixosCfg =
    {
      hosts,
      extraHosts ? { },
    }:
    mapAttrs (_: v: genNixosCfg v) hosts |> mergeWith extraHosts;

  # mapTestCfg =
  #   pkgs:
  #   builtins.readDir ../../tests
  #   |> lib.filterAttrs (n: t: t == "regular" && lib.hasSuffix ".nix" n)
  #   |> builtins.attrNames
  #   |> (3
  #     files:
  #     lib.genAttrs (map (lib.removeSuffix ".nix") files) (test: {
  #       testname = test;
  #       inherit pkgs;
  #     })
  #   )
  #   |> mapAttrs (_: v: genTestCfg v)
  #   |> mergeWith { };

  eachSystem = func: lib.mapAttrs func (import ./platforms.nix inputs);

  importPkgs =
    system:
    import nixpkgs {
      inherit system;
    };
}
