{
  lib,
  ...
}:
{
  services.bird = {
    config = lib.mkOrder 5 ''
      protocol bgp Servperso_V6 from client {
              neighbor 2a0c:b640:10::2:ffff as 34872;
      }
      protocol bgp RS1_LOCIX_DUS_V4 from rs_peer {
              neighbor 185.1.155.254 as 202409;
      }
      protocol bgp RS2_LOCIX_DUS_V4 from rs_peer {
              neighbor 185.1.155.253 as 202409;
      }
      protocol bgp AS112_LOCIX_DUS_V4 from peers {
              neighbor 185.1.155.112 as 112;
      }
      protocol bgp RS1_LOCIX_DUS_V6 from rs_peer {
              neighbor 2a0c:b641:701::a5:20:2409:1 as 202409;
      }
      protocol bgp RS2_LOCIX_DUS_V6 from rs_peer {
              neighbor 2a0c:b641:701::a5:20:2409:2 as 202409;
      }
      protocol bgp AS112_LOCIX_DUS_V6 from peers {
              neighbor 2a0c:b641:701:0:a5:0:112:1 as 112;
      }
      protocol bgp ISA_LOCIX_DUS_V4 from peers {
              neighbor 185.1.155.52 as 215500;
      }
      protocol bgp ISA_LOCIX_DUS_V6 from peers {
              neighbor 2a0c:b641:701::a5:21:5500:1 as 215500;
      }
    '';
  };
}
