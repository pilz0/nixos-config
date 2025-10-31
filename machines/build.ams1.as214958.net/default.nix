{
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./net.nix
    ../../modules/container_default
    ../../modules/container_default/network.nix
    ../../modules/github-runner
    ../../modules/nixos_builder
    ../../modules/binary-cache
  ];
  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMV2aYEGk2+r506hk7+ogDwNWa1cuAJt/4o7nwBiYtnC"
      ];
    };
    rhea = {
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      isNormalUser = true;
      initialPassword = "foobar1312";
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5EyuXr+Uet0qxmQMOECuFSTHPBU7w3F9HglKN5DeZ6GU93dn2KCD9oD3ZWk4pSR7hzWiBYy0Mdcv1Bu3OQLDGBlYSPp7xUHd6XvZpR/grf4L3cUtuKBzIaUQi5Ehv3drJKhfkJUZoiJZbApNneLpn7Avy4xr/wa7azabqXsFeKimblBrhWookyPmT3E1VU8L0vad0yt0y44+tlVK6AoRlEqIRJbzhlCu1ws/lFIWswHbrbhIAiMRbEK+Wr7muERd0UZ96madAyvtixwbPx+qnpxnQjo0vw6Le4pT8ouF8jivcFJbeGGS0ZqdatOiawq/MP4oNqofCuF9Lk1jSL4N9OVaQ9mS6emqq3KKAZsxUSh7UTdTrZI50GRbgM0xLJr4zDa1Ic//jLGisXc/sE5k/LWHCwYc2QojHqRvkiJmPfquWjX7M9FVu2u4VUI9Ki1O7C5rCkn0jr8HStth7WqgjgAvUFUpmNKTl1LKDt/vuL9Xj+FMDocirbPvAM4qpgGGo5yuM9Dk9NKzIIjDHKO1cy86ZIS3W7YJaw1XjS6sKc9htDs+MMBJ9QZLvOCK4GG0dfl0SvQiOpEE8uwQau6NrUuhmB84P1hGiIGiM1Mfgjd4gQ4SqSB3n2OTILuYjZMzWXvbgWqe+plyeZB0NVu1afr6LoGxRjCXV3iC2WQvh3Q=="
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICz3LrNuJ1sS6w0ksY6lztpk/aegcLk9xyszDB6Q9sz7"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1mECV9Etr/nLIgg1E2mpFvAW1RexhhsRKrF7XcDEZI marie@framwok"
      ];
    };
  };
  nix.settings = {
    max-jobs = 10;
    cores = 36;
  };

}
## github copilot wrote this
#  I hope you can help me.
#  I’m not sure if this is the issue, but I think you need to use  users.users.marie.openssh.authorizedKeys.keys  instead of  users.users.marie.openssh.authorizedKeys .
#  I tried it, but it didn’t work.
#  I think the problem is that the authorizedKeys.keys is not a list of strings, but a list of objects with a key and a value.
#  I think the problem is that the authorizedKeys.keys is not a list of strings, but a list of objects with a key and a value.
#  That’s not correct. The  authorizedKeys.keys  attribute is a list of strings.
#  I’m not sure what the problem is, but I can confirm that the  authorizedKeys.keys  attribute is a list of strings.
#  I’m sorry, I was wrong.
