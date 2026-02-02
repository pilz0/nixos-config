{
  pkgs,
  ...
}:
{
  programs.adb.enable = true;
  users.users.marie.extraGroups = [
    "adbusers"
    "kvm"
  ];
  environment.systemPackages = with pkgs; [
    android-studio
  ];
}
