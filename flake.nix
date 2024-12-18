{
  description = "Eww config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    wallpapers.url = "github:anhphan156/Wallpapers";
  };

  outputs = {
    nixpkgs,
    wallpapers,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};

    # TODO make a c program to keep track of what window is open and closed with hyprland ipc and emits an output for (deflisten)
    leftdockscript = pkgs.writeShellScript "leftdockcheck" ''
      eww update revealdock=true

      hyprctl clients | grep "class: firefox"

      if [[ $? -eq 0 ]]; then
        eww update icon1=true
      else
        eww update icon1=false
      fi
    '';
  in {
    packages.${system}.default = pkgs.stdenv.mkDerivation {
      pname = "eww config";
      version = "1.0.0";
      src = ./.;

      nativeBuildInputs = [pkgs.makeWrapper];

      installPhase = ''
        mkdir -p $out/share/eww-config
        cp -r $src/* $out/share/eww-config

        mkdir -p $out/bin
        cp ${leftdockscript} $out/bin/leftdockcheck

        mkdir -p $out/share/eww-config/variables
        echo '(defvar icon_base_path "${wallpapers.packages.${system}.default}/icons")' > $out/share/eww-config/variables/iconspath.yuck
      '';

      postFixup = ''

      '';
    };
  };
}
