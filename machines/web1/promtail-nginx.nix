{
  config,
  ...
}:
{
  services.promtail = {
    configuration = {
      scrape_configs = [
        {
          job_name = "nginx";
          static_configs = [
            {
              targets = [ config.networking.hostName ];
              labels = {
                job = "nginx";
                __path__ = "/var/log/nginx/*log";
                host = config.networking.hostName;
              };
            }
          ];
        }
      ];
    };
  };

}
