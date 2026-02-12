let
  marielap = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1mECV9Etr/nLIgg1E2mpFvAW1RexhhsRKrF7XcDEZI marie@framwok"
  ];
  Laptop = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxK1XaK+2oivpGVJ/vYRrqbWhaYE6hEgmDOfkGvde8L root@framwok"
  ];
  serva = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFNa2EBrRNnGMjGSNjlD1pXo9YRuq6rOsC3v+6VAg2F root@nixos"
  ];
  grafana = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDYuCqvjPnagrUSiRaw8pug/5E9i99pc2VHWkt43fRQI2c78k9TATdf2fTZw0hQYD2iNfUjLBD4ModnBR3QKDyzqhfQjVCUTtNmmEyCboYicDiTXAh3U5i41dWMh4lZjpNwbYrciXDAWIBY++kpmicG2Gt8tWDLkPMSoFVO1cOMlXuViDcAJx+YxzL38ufaolRsUNrP0ZYOcNAA7W3PtDyZ1KGkb/fxf3Irrp2QquWF2V3xfY8eFx282mbUP/1JFxob6xkVw0QsEjDlVo05fX7PX+XCwzIWgmWhFFQWygSZN9qE02YDbDTW1kq25yJCLBVHJG79WBbleIxyX0HpXvewKAQC2+FLiXiMfHcpLt6DrSLEKOPfHhijaOoMlyoM6bJli14Zqjv5R8IG0ytJ2QDcVFWcX9XK9cYGPv1ZLfqoV7HY6gvJOiCyuzdiECF2nMsbL/YaKtMO59Bg2Iiv7D4Tcj9+rmAQZE4lx5h1WKSvHwUCVhav1NsMXT/UZwp+wvhE7KZvkHGSfDKTFNvqdBdCe6Xzih2fAhH97chS0qPdlpG4nnOq2kv9A/PRDteZNOX233UE8E7LFQF95eFb6Hyk3cVnfjSVbah976ZAQlrGDI3Jg/Fh7Ocx17UcNcEB4Jpec8zEvyBMziEYhCMIxGGtDzsQS7DuDTclTHz2eNVvqQ== root@grafana"
  ];
  web1_host = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC39tIpx/ZGNuF8D770Aq10g8JBKZ12JdfXk8VgdJqqzm4Fro7Zyj7945iFqzEPkAE1HR+sSj/GK+TsayHhgYF0/Zd5Rq38aWPlRCLlq9XT5BCAMh5UVSzha0uyEVs+RiOgsZs+6z0YYtj1uTv6p7fYgSVQfZs4Ry/0Ss3hoxw3gzcv/Klr/EzZWlfEW1TyCXZS6u4m4odIk/rcdR0/2f/eDOZKW2mH9H6oq6kMW252iojFNuzpJ+IM/5oZX+bskIswkMBU0xabHRJ7Pa2smygkFflLrLdUIqpcEmPc5n6CePuX8ioAhzYmZQtTVBSkR0IVnZcTmrVZU/sT/QlSoVqwo4rB3xNhHKgHCEgVhVGvwJ7oMUZJMGGYjR9QoORVV8CaMnSqqqQS/rri606/DSqUEtHslRX7z3MrfYqnr03yaznGNkRMg6U8qI7oxy12W4VvqR5vPDBUSVm80kun9Coe/0r/8AkUoLiTh7oNnOW9YCshis+IEg+dV8y9lknv4njBCKVdrKokO3hB/TXa2Oi5Doxp0XVIgrIfNZkDhfb8Z9Hkl4hXkUUjsIvXc2Rt4h9Dp3VuaTzcWtPWAqXSyyj6+mzmPlerx+Rd3Sk5hBFw1EL90d7dpYHs2ucKrVYYK8L2SALyZgHnPjz18O6lp3AJrE/SqIVnYhuKUDigpXQdUQ== root@web1"
  ];
  jellyfin = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5p8m0YGdCVu6GLnfTcvKczx9FQ6qkBiGLHgYB4F/rIjqZmS9WTeu1a/UdmibBEAqKONSv2Er1lfvNtCDqbtv07a+RKw23VnS23WLWmUNk2ivgqg/Q4z6IwZFcGAcOwdNzB2PlFruJgLQJcfPsqPQ6akRmwgxJaK7CEjzz6wmB0eqNRdN4NgTBBgoukG8jQOr+MvUaB+DS6AEwZMzXLVyW3jsCRDdrry7Fm1XLQYdu/jUvWaNfA4B+jj9EWcVKrfq66iv4q8s4rxoN2Rs+11+txvp9P+wwgl8S1w7CxC49NFI6HX5ubVgoypzJhL7RIz//AZw5BwTeKlvl31O+R6Ft96krt5wS6LEauUdVMUf9xshNQMH5kuquOZwBoTcUww2H0RY/K6Hb1ehq1yfjnSp74OUfk/ouCM+Z7emeq5QwJ5eueJxDy0FI/cp140w2LXLZJYzJaixBXPJwvlGxBAqUZQd8HbgY/m3CuF2yNbepKeuXEOfVb5BAA4ZDVQze/iK2iwesXvV2axi09u5hcW+/Q1WWVv/ablvOxBUQOn6b1+mSaVO9CVALrs25nMT9MGsIdhBZCvLxZleXM7g/lOfOi4GZYSEIiyghIFHl5Ce/npHVJbhJFGsAI+HrSWH8R80hJS70JbP5GZ8Zn184y5alIi5Qn4FhGF/yhjoIrZWDEQ== root@jellyfin"
  ];
  dn42 = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9ZRhIbnEwIHR3/V1mXqr3s9Zn/dh/ESscvpFyOwOPtju9AaO8zyf8r7qiysMrZGeigGl8tDvoIVWGeSvc9vnrPVo73wAwePfOfHJUSaZHGT2ER43QtvZgImNU6DCxTaGsSzYr8TKCAUtl7vfhPAFciz/PPwqsuKtCmjrXWpbFMleOMua3BvUuQv1HWYLidqnFs+S/qZ+IydZjl9kwpSY8roiX0AJ+ZgYFvA9K1NQJrcEbmWGG7Y9ae+TCYoK+hZuOzUdS7VcBj8Pxta6dbETZN6Bg27vZHDwqPsXG9YCRayb3JOeNVPTg/1JgrvSju5a6b4GCpvp5jePKKy92cd46a1OpLIQF2Me6+2hEuYQA9/G83bhft8Y7lo1aKOckLRlTIXLMxjs+2cHyGtvQUfjiJF9GNsAjM0bjUg9avtYyOdl7EZj/opubJ0ZQypLp37a6SvdB0aO3PZziCwaHM4cenXPN8+BFgPQyJn1nh0mY+pBOIvUE1pDN6FV4aZF2M4rOZtkcLyp7N0EOVCtPrHKQYBrxPh8FU0zlKgqK7ls6b4K85RoyS86XQ8ElZzoKaVAbW31Wy8PZRtUJlsLBWPPUIxavhyTpzxJcMyL0MvNqZn40FtjeQPoYhA9t6ns6MDW/10pIHqngPfSvYsr3M3djISp6dWHPSnZyJyq6AVRxYQ== root@dn42"
  ];
  netbox = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBNFGU7d/tmjOL7yOR6LHPKM2S6EWeBIy4RHzaRCWjpM root@netbox"
  ];
  build = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAy+DchMGEo5Q9Fuu02KERSabQ055pY6VjCqoX+DlZBn root@build"
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
  ];
  macbook-work = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExU28oRh+stgLtfgqUejL601PPV8OKqoVni9W6dna9a"
  ];

  all_hosts =
    Laptop
    ++ marielap
    ++ serva
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
    ++ macbook-work;
in

{
  "nextcloud.age".publicKeys = marielap ++ serva ++ macbook-work;
  "nextcloud-secrets.age".publicKeys = marielap ++ serva ++ macbook-work;
  "rclone.age".publicKeys = Laptop ++ marielap ++ serva ++ grafana ++ macbook-work;
  "restic.age".publicKeys = Laptop ++ marielap ++ serva ++ grafana ++ macbook-work;
  "smtp.age".publicKeys = marielap ++ serva ++ grafana ++ macbook-work;
  "grafana.age".publicKeys = marielap ++ serva ++ grafana ++ macbook-work;
  "wg.age".publicKeys = marielap ++ serva ++ dn42 ++ macbook-work;
  "nixarr-wg.age".publicKeys = marielap ++ serva ++ jellyfin ++ macbook-work;
  "HashedPassword.age".publicKeys = marielap ++ Laptop ++ serva ++ macbook-work;
  "cloudflare_cert.age".publicKeys = marielap ++ serva ++ web1_host ++ grafana ++ macbook-work;
  "cloudflare_key.age".publicKeys = marielap ++ serva ++ web1_host ++ grafana ++ macbook-work;
  "s3-mastodon.age".publicKeys = marielap ++ serva ++ macbook-work;
  "netbox.age".publicKeys = marielap ++ netbox ++ macbook-work;
  "harmonia.age".publicKeys = marielap ++ build ++ macbook-work;
  "nixbuildssh.age".publicKeys = all_hosts;
  "forgejo-runner-token.age".publicKeys = marielap ++ build ++ macbook-work;
  "github-runner.age".publicKeys = marielap ++ build ++ macbook-work;
  "work-bw-session.age".publicKeys = marielap ++ macbook-work;
  "wg-key-ams1-dn42.age".publicKeys = marielap ++ macbook-work ++ dn42;
}
