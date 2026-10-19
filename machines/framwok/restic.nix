{
  pilz.services.restic-client.enable = true;
  services.restic.backups.onedrive = {
    paths = [
      "/home/marie"
    ];
    exclude = [
      "*cache*"
      "*/.local/share/Trash/*"
      "*/.steam/*"
      "*monero*"
      "*.android*"
    ];
  };
}
