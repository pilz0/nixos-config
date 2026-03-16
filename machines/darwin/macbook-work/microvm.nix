{
   inputs,
  ...
}:
{
  imports = [
    inputs.microvm.nixosModules.host
  ];

  microvm = {
    vms = {
      vm1 = {
        interfaces = [
          {
            type = "user";

            id = "vm-a1";
            mac = "02:00:00:00:00:01";
          }
        ];
        vcpu = 2;
        mem = 2000;
        pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
        config = {
          imports = [
            ../../modules/common
          ];
          microvm.shares = [
            {
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
              tag = "ro-store";
              proto = "virtiofs";
            }
          ];
        };
      };
    };
  };
}
