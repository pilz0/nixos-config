{
  services.monero = {
    enable = true;
    extraConfig = ''
      out-peers=32
      in-peers=32
      rpc-restricted-bind-ip=0.0.0.0
      rpc-restricted-bind-port=18089
      enforce-dns-checkpointing=true
      enable-dns-blocklist=true
      no-igd=true
      no-zmq=true
    '';
  };
}
