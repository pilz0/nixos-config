{
  ...
}:
{
  services.nginx = {
    enable = true;
  };

  systemd.tmpfiles.rules = [
    "d /var/cache/nginx/tilecache 0755 nginx nginx -"
    "d /var/cache/nginx/temp 0755 nginx nginx -"
  ];

  services.nginx = {
    appendHttpConfig = ''
      proxy_cache_path /var/cache/nginx/tilecache levels=1:2 keys_zone=tilecache:64m max_size=1g inactive=7d;
      proxy_temp_path /var/cache/nginx/temp;
      proxy_cache_lock on;
      proxy_cache_lock_timeout 10s;
    '';

    virtualHosts."localhost" = {
      #    enableACME = true;
      #    forceSSL = true;
      locations."/osm/" = {
        proxyPass = "https://tile.openstreetmap.org/";
        extraConfig = ''
          proxy_set_header User-Agent "Mozilla/5.0 (compatible; OSMTileCache/1.0; +mailto:ops@darmstadt.freifunk.net; +https://map.darmstadt.freifunk.net/)";
          proxy_set_header Host tile.openstreetmap.org;
          proxy_http_version 1.1;
          proxy_ssl_server_name on;
          proxy_ssl_name tile.openstreetmap.org;
          proxy_set_header Accept-Encoding "";
          proxy_set_header Connection "";

          add_header X-Cache-Status $upstream_cache_status;
          add_header X-Cache-Upstream-Status $upstream_http_x_cache_status;

          # Use the cache zone defined above
          proxy_cache tilecache;
          proxy_cache_key $uri$is_args$args;

          proxy_cache_valid any 7d;
          proxy_cache_use_stale error timeout updating invalid_header http_500 http_502 http_503 http_504 http_403 http_404;
          proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504 http_403 http_404;

          proxy_hide_header Via;
          proxy_hide_header X-Cache;
          proxy_hide_header X-Cache-Lookup;
          proxy_hide_header X-Cache-Status;
          proxy_hide_header Strict-Transport-Security;
          proxy_hide_header Set-Cookie;

          proxy_ignore_headers Set-Cookie;
          proxy_ignore_headers X-Accel-Expires Expires Cache-Control;

          expires 7d;
        '';
      };
    };
  };
}
