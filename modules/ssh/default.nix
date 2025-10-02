{

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
    banner = ''
      <p><div class='plussize'>
      "MRX hatte drei Regeln:
      <BR>Erstens: Kein System ist sicher
      <BR>Zweitens: Dreistigkeit siegt
      <BR>Drittens: begrenze Deinen Spass nicht nur auf die virtuelle Welt"
      </div>
      _____________________________________________________________________
      <p><div class='plussize'>"Du musst nur dreist genug sein, dann liegt Dir die Welt zu Füßen."</div>
    '';
  };
}
