{ config, lib, ... }:
let
  cfg = config.mymodules.git;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.mymodules.git.enable = mkEnableOption "git";
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      config = {
	init.defaultBranch = "main";
	alias = {
	  l = "log";
	  lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cD) %C(bold blue)<%an>%Creset' --abbrev-commit";
	};
	user = {
	  name = "Artur Manuel";
	  email = "balkenix@outlook.com";
	  signingKey = "03C722E31B490B35";
	};
	commit.gpgsign = true;
	url = {
          "https://github.com/" = {
            insteadOf = [
              "gh:"
              "github:"
            ];
          };
        };
      };
    };
  };
}
