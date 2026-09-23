{
  pkgs,
  ...
}:
{
  services.wordpress = {
    webserver = "nginx";
    sites."flohannes.de" = {
      package = pkgs.wordpress_7_0;
      plugins = {
        inherit (pkgs.wordpressPackages.plugins)
          disable-xml-rpc
          wordpress-seo
          ;
      };
      languages = [ pkgs.wordpressPackages.languages.de_DE ];
      settings = {
        WPLANG = "de_DE";
        FORCE_SSL_ADMIN = true;
      };
      extraConfig = ''
        // Enable the plugin 
        if ( !defined('ABSPATH') )
          define('ABSPATH', dirname(__FILE__) . '/');
        require_once(ABSPATH . 'wp-settings.php');
        require_once ABSPATH . 'wp-admin/includes/plugin.php';
        activate_plugin( 'disable-xml-rpc/disable-xml-rpc.php' );
        $_SERVER['HTTPS']='on';
      '';
    };
  };
  services.nginx.virtualHosts."flohannes.de" = {
      enableACME = true;
      forceSSL = true;
    };
}
