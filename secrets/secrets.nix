let
  marielap = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1mECV9Etr/nLIgg1E2mpFvAW1RexhhsRKrF7XcDEZI marie@framwok"
  ];
  Laptop = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxK1XaK+2oivpGVJ/vYRrqbWhaYE6hEgmDOfkGvde8L root@framwok"
  ];
  grafana = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtZhAEvENbPh39Jou3tNbz/3mPzRe+FLfn938I3kSMu root@grafana"
  ];
  web1_host = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAk5vEQRmYmmUmWEhh6lLnip/mEu4E52RcnuubaG09qO root@web1"
  ];
  jellyfin = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5p8m0YGdCVu6GLnfTcvKczx9FQ6qkBiGLHgYB4F/rIjqZmS9WTeu1a/UdmibBEAqKONSv2Er1lfvNtCDqbtv07a+RKw23VnS23WLWmUNk2ivgqg/Q4z6IwZFcGAcOwdNzB2PlFruJgLQJcfPsqPQ6akRmwgxJaK7CEjzz6wmB0eqNRdN4NgTBBgoukG8jQOr+MvUaB+DS6AEwZMzXLVyW3jsCRDdrry7Fm1XLQYdu/jUvWaNfA4B+jj9EWcVKrfq66iv4q8s4rxoN2Rs+11+txvp9P+wwgl8S1w7CxC49NFI6HX5ubVgoypzJhL7RIz//AZw5BwTeKlvl31O+R6Ft96krt5wS6LEauUdVMUf9xshNQMH5kuquOZwBoTcUww2H0RY/K6Hb1ehq1yfjnSp74OUfk/ouCM+Z7emeq5QwJ5eueJxDy0FI/cp140w2LXLZJYzJaixBXPJwvlGxBAqUZQd8HbgY/m3CuF2yNbepKeuXEOfVb5BAA4ZDVQze/iK2iwesXvV2axi09u5hcW+/Q1WWVv/ablvOxBUQOn6b1+mSaVO9CVALrs25nMT9MGsIdhBZCvLxZleXM7g/lOfOi4GZYSEIiyghIFHl5Ce/npHVJbhJFGsAI+HrSWH8R80hJS70JbP5GZ8Zn184y5alIi5Qn4FhGF/yhjoIrZWDEQ== root@jellyfin"
  ];
  dn42 = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEk0MhPUq/EcX8+X2zepDSl7t3Eluv0YkOIilGFkFv8p root@dn42"
  ];
  netbox = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBNFGU7d/tmjOL7yOR6LHPKM2S6EWeBIy4RHzaRCWjpM root@netbox"
  ];
  build = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOaCOf4RpWomwnwTIMvFWO0MmtBIyY79SfJL8DRSlaGy root@CT106"
  ];
  rpki = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWxHkhwJPhT0hL1TGWjIxWSRPzMvGleKE9Jq9mCUXOI root@rpki"
  ];
  tor1 = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA2lst0kq6NAlb+Cc3qMHiRck8m6TxsbIY1xw4c2Uy6+ root@tor1"
  ];
  tor2 = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKnLmMvgQyXmFLlpUEy3WZ5FgUX3FSY+Akc+xbbnp8si root@tor2"
  ];
  tor3 = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICvef2S49SyNxnsHwnoWFLU1ujorffUg9U30kyZVFdfH root@tor3"
  ];
  tor4 = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPKSD/jZi43fTDPmTWEaVAbPP2mcsNIuCRpJ6V08xS3f root@tor4"
  ];
  tor5 = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFiQj9hJyXjUc2j61qSy/A2bdAUnnporPGV0sv483gxT root@tor5"
  ];
  tor6 = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJU7Un7wPWlCApfYPgsnBTEh0nyC7AyUtCgnm/qer6I/ root@tor6"
  ];
  tor7 = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILBJuIu8Xovd9h2oSltlzMYHYY5aE+L8xMU1YYxfNpQs root@tor7"
  ];
  tor8 = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAYdoA2HeJBzSnUyOkvEsd2YOK/9VVT4rWAlp69WOdC4 root@tor8"
  ];
  snakii = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/+iN407+HsfHbbC3tfdA8Yf4TZ08qXQMb4tb/SDAs+"
  ];
  fedi-bot = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjqRp9g0aeaUjRIG8r6qB8kFdvDUYFV+6DzRQBEYw0Z root@fedi-bot"
  ];
  jetson-warcrime = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOessry4YtF08jzZv2EeNEnsLz36Un7SQ7tBDmSq0ec7 root@nixos"
  ];
  build-aarch64 = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmKUILzb3kuLq4g3MD7NJEIXIZghQqozqRa/SdYoYzK root@build-aarch64"
  ];

  all_hosts =
    Laptop
    ++ marielap
    ++ grafana
    ++ web1_host
    ++ jellyfin
    ++ dn42
    ++ netbox
    ++ build
    ++ rpki
    ++ tor1
    ++ tor2
    ++ tor3
    ++ tor4
    ++ tor5
    ++ tor6
    ++ tor7
    ++ tor8
    ++ jetson-warcrime
    ++ build-aarch64
    ++ fedi-bot;
in
{
  "rclone.age".publicKeys = Laptop ++ marielap ++ grafana;
  "restic.age".publicKeys = Laptop ++ marielap ++ grafana;
  "smtp.age".publicKeys = marielap ++ grafana;
  "grafana.age".publicKeys = marielap ++ grafana;
  "wg.age".publicKeys = marielap ++ dn42;
  "nixarr-wg.age".publicKeys = marielap ++ jellyfin;
  "HashedPassword.age".publicKeys = marielap ++ Laptop;
  "cloudflare_cert.age".publicKeys = marielap ++ web1_host ++ grafana ++ snakii;
  "cloudflare_key.age".publicKeys = marielap ++ web1_host ++ grafana ++ snakii;
  "s3-mastodon.age".publicKeys = marielap;
  "netbox.age".publicKeys = marielap ++ netbox;
  "harmonia.age".publicKeys = marielap ++ build;
  "nixbuildssh.age".publicKeys = all_hosts ++ snakii;
  "github-runner.age".publicKeys = marielap ++ build;
  "wg-key-ams1-dn42.age".publicKeys = marielap ++ dn42;
  "fedi-bot-hfToken.age".publicKeys = marielap ++ jellyfin ++ snakii ++ fedi-bot ++ jetson-warcrime;
  "fedi-bot-fediToken.age".publicKeys = marielap ++ jellyfin ++ snakii ++ fedi-bot ++ jetson-warcrime;
  "tsig_ns.age".publicKeys = marielap ++ netbox ++ dn42 ++ build-aarch64;
}
