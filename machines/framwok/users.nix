{
  users.users = {
    marie = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "dialout"
        "docker"
      ];
    };
  };
}
