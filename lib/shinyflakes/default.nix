# modified version of https://woof.rip/emily/nixfiles/src/branch/main/lib/shinyflakes/default.nix
{ nixpkgs, ... }@inputs:
let
  inherit (nixpkgs) lib;
  inherit (builtins) mapAttrs;

  mergeWith = x: y: lib.recursiveUpdate y x;

  genColmenaCfg = name: host: {
    deployment = {
      allowLocalDeployment = builtins.any (hostName: hostName == name) [ "framwok" ];
      buildOnTarget = false;
      targetHost = host.config.pilz.deployment.targetHost;
      targetPort = 22;
      targetUser = "root";
      #  tags = host.config.pilz.deployment.tags;
    };
    imports = host._module.args.modules;
    nixpkgs.system = host.config.nixpkgs.system;
  };

  genNixosCfg =
    {
      hostname,
      system ? "x86_64-linux",
    }:
    lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ../deployment
        ../../modules/common
        ../../machines/${hostname}
        inputs.agenix.nixosModules.default
        (
          { ... }:
          {
            nixpkgs.hostPlatform.system = system;
          }
        )
      ];
    };
in
{
  mapHostsMerge =
    hdir: extraCfg:
    builtins.readDir hdir
    |> lib.filterAttrs (n: t: t == "directory" && n != "_minimal")
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
    lib.filterAttrs (name: _: !(lib.hasSuffix "-minimal" name)) nixosCfg
    |> mapAttrs genColmenaCfg
    |> mergeWith extraCfg;

  mapNixosCfg =
    {
      hosts,
      extraHosts ? { },
    }:
    mapAttrs (_: v: genNixosCfg v) hosts |> mergeWith extraHosts;

  eachSystem = func: lib.mapAttrs func (import ./platforms.nix inputs);

  importPkgs =
    system:
    import nixpkgs {
      inherit system;
    };
}
