{
  pkgs,
  ...
}:
{
  users.users.marie.extraGroups = [
    "kvm"
  ];
  environment.systemPackages = with pkgs; [
    android-studio
    android-tools
  ];
}
