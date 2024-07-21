{ config, inputs, pkgs, lib, ... }:
let
  cfg = config.mymodules.emacs;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.mymodules.emacs.enable = mkEnableOption "emacs";
  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (import inputs.emacs)
      inputs.pankomacs.overlays.default
    ];

    services.emacs = {
      enable = true;
      package = pkgs.pankomacs;
      startWithGraphical = true;
      defaultEditor = true;
      install = true;
    };
  };
}
