{ config
, lib
, ...
}:
let
  cfg = config.mymodules.virtualisation;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.mymodules.virtualisation = {
    enable = mkEnableOption "libvirt and stuff";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
}
