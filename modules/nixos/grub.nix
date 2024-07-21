{ config
, lib
, ...
}:
let
  cfg = config.mymodules.grub;
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    ;
  inherit
    (lib.types)
    str
    ;
  mkStringOption = def: desc:
    mkOption {
      type = str;
      default = def;
      description = desc;
    };
in
{
  options.mymodules.grub = {
    enable = mkEnableOption "grub";
    efiSupport = mkEnableOption "efi";
    device = mkStringOption "/dev/sda" "device";
  };

  config = lib.mkIf cfg.enable {
    boot.loader.grub = {
      enable = true;
      enableCryptodisk = true;
      efiInstallAsRemovable = cfg.efiSupport;
      device =
        if cfg.efiSupport
        then "nodev"
        else cfg.device;
      efiSupport = true;
    };
  };
}
