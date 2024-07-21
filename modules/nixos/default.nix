{
  fonts = import ./fonts.nix;
  alacritty = import ./alacritty;
  grub = import ./grub.nix;
  direnv = import ./direnv.nix;
  xorg = import ./xorg;
  sway = import ./sway;
  git = import ./git.nix;
  emacs = import ./emacs.nix;
  pipewire = import ./pipewire.nix;
  chromium = import ./chromium.nix;
  flakes = import ./flakes.nix;
  virtualisation = import ./virtualisation.nix;
}
