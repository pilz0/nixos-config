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
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL9oSm2h9Grq49CTX8MfRMn7vFPWPFdpyu9e1btshv93 root@jellyfin"
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
  emily = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/+iN407+HsfHbbC3tfdA8Yf4TZ08qXQMb4tb/SDAs+"
  ];
  fedi-bot = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjqRp9g0aeaUjRIG8r6qB8kFdvDUYFV+6DzRQBEYw0Z root@fedi-bot"
  ];
  jetson-warcrime = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMwN/bH7k75m4f2RwdeNsnnNRhCKQVtfZsbgR1zVvVAH root@jetson-warcrime"
  ];
  build-aarch64 = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmKUILzb3kuLq4g3MD7NJEIXIZghQqozqRa/SdYoYzK root@build-aarch64"
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

  tor = tor1 ++ tor2 ++ tor3 ++ tor4 ++ tor5 ++ tor6 ++ tor7 ++ tor8 ++ build-aarch64;
in
{
  "rclone.age".publicKeys = Laptop ++ marielap ++ grafana;
  "restic.age".publicKeys = Laptop ++ marielap ++ grafana;
  "smtp.age".publicKeys = marielap ++ grafana;
  "grafana.age".publicKeys = marielap ++ grafana;
  "wg.age".publicKeys = marielap ++ dn42;
  "nixarr-wg.age".publicKeys = marielap ++ jellyfin;
  "cloudflare_cert.age".publicKeys = marielap ++ web1_host ++ grafana ++ emily;
  "cloudflare_key.age".publicKeys = marielap ++ web1_host ++ grafana ++ emily;
  "s3-mastodon.age".publicKeys = marielap;
  "netbox.age".publicKeys = marielap ++ netbox;
  "harmonia.age".publicKeys = marielap ++ build ++ build-aarch64;
  "nixbuildssh.age".publicKeys = all_hosts ++ emily;
  "wg-key-ams1-dn42.age".publicKeys = marielap ++ dn42;
  "fedi-bot-hfToken.age".publicKeys = marielap ++ jellyfin ++ emily ++ fedi-bot;
  "fedi-bot-fediToken.age".publicKeys = marielap ++ jellyfin ++ emily ++ fedi-bot ++ jetson-warcrime;
  "tsig_ns.age".publicKeys = marielap ++ netbox ++ dn42 ++ build-aarch64;
  "tor-familiy.age".publicKeys = marielap ++ tor;
  "wg-jetson.age".publicKeys = marielap ++ jetson-warcrime;
  "smtp-flohannes.age".publicKeys = marielap ++ web1_host ++ emily;
}
