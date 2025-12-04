{
  config,
  ...
}:
{
  age.secrets = {
    s3-mastodon = {
      file = ../../secrets/s3-mastodon.age;
      owner = "mastodon";
      group = "mastodon";
    };
  };

  services = {
    mastodon = {
      enable = true;
      localDomain = "m.pilz.foo";
      configureNginx = true;
      smtp = {
        fromAddress = "t3st1ng1312@cock.li";
        user = "t3st1ng1312@cock.li";
        passwordFile = "/foo/bar";
        host = "mail.cock.li";
        authenticate = true;
        createLocally = false;
        port = 465;
      };
      streamingProcesses = 2;
      extraEnvFiles = [
        config.age.secrets.s3-mastodon.path
      ];
      trustedProxy = "2a0e:8f02:f017::2";
    };

    postgresqlBackup = {
      enable = true;
      databases = [
        "mastodon"
      ];
    };
  };
  services.nginx.virtualHosts.${config.services.mastodon.localDomain} = {
    forceSSL = false;
    enableACME = true;
  };
}
