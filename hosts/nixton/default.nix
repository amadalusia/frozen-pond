{ config
, lib
, pkgs
, inputs
, ...
}:
let
  mkUser =
    { user
    , desc
    ,
    }: {
      name = user;
      home = "/home/${user}";
      isNormalUser = true;
      description = desc;
      extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
      shell = config.programs.fish.package;
    };
in
{
  # Shit I need to import...
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    inputs.disko.nixosModules.disko
    inputs.hardware.nixosModules.common-hidpi
    inputs.hardware.nixosModules.common-pc-laptop-ssd
    inputs.self.nixosModules.flakes
    inputs.self.nixosModules.fonts
    inputs.self.nixosModules.alacritty
    inputs.self.nixosModules.grub
    inputs.self.nixosModules.direnv
    inputs.self.nixosModules.xorg
    inputs.self.nixosModules.sway
    inputs.self.nixosModules.git
    inputs.self.nixosModules.emacs
    inputs.self.nixosModules.pipewire
    inputs.self.nixosModules.chromium
    inputs.self.nixosModules.virtualisation
  ];

  # Some bloat modules I created on my own.
  mymodules = {
    alacritty.enable = true;
    grub = {
      enable = true;
      efiSupport = true;
    };
    fonts = {
      enable = true;
      packages.extras = [
	pkgs.noto-fonts
        pkgs.nerdfonts
      ];
    };
    direnv.enable = true;
    xorg = {
      enable = true;
      hiDPI = true;
      i3.enable = true;
    };
    sway.enable = true;
    git.enable = true;
    emacs.enable = true;
    chromium.enable = true;
    pipewire.enable = true;
    virtualisation.enable = true;
  };

  # Networking would be useless
  networking = {
    hostName = "nixton";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd"; # I just like IWD!
    };
  };

  # Living in the UK right now. So I will set this accordingly.
  time.timeZone = "Europe/London";

  # Más eu sou portugês.
  i18n.defaultLocale = "pt_PT.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "pt-latin1"; # Because I'm rocking a Portuguese MacBook Pro from 2014. B^)
  };

  # I think I like X.org better.
  services.xserver.xkb = {
    layout = "pt";
    variant = "mac";
    options = "ctrl:nocaps"; # Bang on Emacs setup!
  };

  # Add some OpenGL support
  hardware.opengl.enable = true;

  # Enable this even if it was already enabled. Better safe than sorry after all!

  # Add my user with my own lambda! I like the extra work.
  users.users.artur = mkUser {
    user = "artur";
    desc = "Artur Manuel";
  };

  # Adding some packages, can't run a system on an empty set of packages!
  # (Well, it's a list in this case... but I do not care!)
  programs = {
    yazi.enable = true;
    fish = {
      enable = true;
      vendor = {
        functions.enable = true;
        config.enable = true;
        completions.enable = true;
      };
    };
  };

  environment = {
    systemPackages =
      let
        systemPackages = builtins.attrValues {
          inherit
            (pkgs)
            fastfetch
            fzf
            fd
            ripgrep
            bat
            grc
            pciutils
            lshw
	    vesktop
            ;
        };

        fishPlugins = builtins.attrValues {
          inherit
            (pkgs.fishPlugins)
            tide
            grc
            ;
        };
      in
      systemPackages ++ fishPlugins;
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
  # One of the only few times the FSF (and by extension, GNU) made a solid tool.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # A firewall... touch responsibly!
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  # systemd-tmpfiles to use as an alternative to home manager
  systemd.user.tmpfiles.rules =
    let
      wallpaper = pkgs.fetchurl {
        url = "https://i.imgur.com/TMrs2XU.png";
        sha256 = "9rtHCczp4XSdGd0y+hn/KziZPjErrgXhUFcOP73ufNo=";
      };
    in
    [
      "L+ /tmp/wallpaper - - - - ${wallpaper}"
      "L+ ${config.users.users.artur.home}/.Xresources - - - - ${./. + "/configs/Xresources"}"
    ];

  #
  # OPTIONS I HAVE NO NEED TO CHANGE BELOW
  #

  # system.copySystemConfiguration = true;
  system.stateVersion = "24.05"; # especially not this value, it would be an awful idea to change.
}
