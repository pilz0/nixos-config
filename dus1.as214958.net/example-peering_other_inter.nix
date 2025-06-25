{ lib, ... }:
let
  interface = "";
  ownip = "";
  ownip_cidr = "";
  name = "";
  asn = "";
  peerip = "";
  peersubnetcidr = "";
  role = "";
in
{
  systemd.network = {

    networking = {
      interfaces.${toString interface} = {
        ipv6.addresses = [
          {
            address = ownip;
            prefixLength = ownip_cidr;
          }
        ];
      };
    };

    networks."${toString name}" = {
      matchConfig.Name = name;
      address = [ "${toString ownip}/${toString ownip_cidr}" ];
      routes = [
        {
          Destination = peerip + peersubnetcidr;
          Scope = "link";
        }
      ];
      networkConfig = {
        IPv4Forwarding = true;
        IPv6Forwarding = true;
        IPv4ReversePathFilter = "no";
        IPv6AcceptRA = false;
        DHCP = false;
      };

      linkConfig = {
        RequiredForOnline = "no";
      };
    };
  };

  services.bird = {
    config = lib.mkAfter ''
      protocol bgp ${toString name} from dnpeers {
          neighbor ${toString peerip}%${toString name} as ${toString asn};
          local role ${toString role};
      }
    '';
  };
}
