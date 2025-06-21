{
  config,
  ...
}:
{
  age.secrets.mailpw = {
    file = ../secrets/smtp.age;
    owner = "mastodon";
    group = "mastodon";
  };
  age.secrets.writefreely = {
    file = ../secrets/writefreely.age;
    owner = "writefreely";
    group = "writefreely";
  };
  age.secrets.s3-mastodon = {
    file = ../secrets/s3-mastodon.age;
    owner = "mastodon";
    group = "mastodon";
  };
  #      services.ollama = {
  #        enable = true;
  #        acceleration = "cuda";
  #        loadModels = [ "llama3.2" ];
  #     };
  #      services.open-webui = {
  #        enable = true;
  #       port = 2315;
  #      };

  services.mastodon = {
    enable = true;
    localDomain = "m.pilz.foo"; # Replace with your own domain
    configureNginx = true;
    smtp = {
      fromAddress = "t3st1ng1312@cock.li"; # Email address used by Mastodon to send emails, replace with your own
      user = "t3st1ng1312@cock.li";
      passwordFile = config.age.secrets.mailpw.path;
      host = "mail.cock.li";
      authenticate = true;
      createLocally = false;
      port = 465;
    };
    streamingProcesses = 2; # Number of processes used by the mastodon-streaming service. recommended is the amount of your CPU cores minus one.
    extraEnvFiles = [
      config.age.secrets.s3-mastodon.path
    ];
  };
  services.postgresqlBackup = {
    enable = true;
    databases = [
      "mastodon"
      "nextcloud"
    ];
  };
}
