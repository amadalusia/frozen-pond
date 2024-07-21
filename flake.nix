{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    utils.url = "github:numtide/flake-utils";
    parts.url = "github:hercules-ci/flake-parts";
    disko.url = "github:nix-community/disko";
    dgt.url = "github:AdisonCavani/distro-grub-themes";
    hardware.url = "github:NixOS/nixos-hardware";
    pankomacs.url = "github:amadalusia/pankomacs";
    emacs.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs:
    inputs.parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
      ];

      flake = {
        nixosConfigurations = {
          nixton = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [
              ./hosts/nixton
            ];
          };
        };
        nixosModules = import ./modules/nixos;
        overlays = import ./overlays { inherit inputs; };
      };

      perSystem = { pkgs, system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
	  inherit system;
	  overlays = let
	    selfOverlays = builtins.attrValues {
	      inherit (inputs.self.overlays)
	        additions
	        ;
	    };
	  in selfOverlays ++ [
            (import inputs.emacs)
	    inputs.pankomacs.overlays.default
	  ];
	};
        devShells.default = pkgs.mkShell {
          packages = builtins.attrValues {
            inherit
              (pkgs)
              nixd # idk about this, but i will when i get to this point :^)
              ;
          };
        };

        formatter = pkgs.nixpkgs-fmt; # as soon as i set up treefmt i am removing this, cant be arsed rn
      };
    };
}
