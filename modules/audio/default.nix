{
  config,
  lib,
  ...
}:
{
  options.pilz.audio.enable = lib.mkEnableOption "";

  config = lib.mkIf config.pilz.audio.enable {
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
