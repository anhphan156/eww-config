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
  in {
    packages.${system}.default = pkgs.stdenv.mkDerivation {
      pname = "eww config";
      version = "1.0.0";
      src = ./.;

      installPhase = ''
        mkdir -p $out
        cp -r $src/* $out

        mkdir -p $out/variables
        echo '(defvar icon_base_path "${wallpapers}/icons")' > $out/variables/iconspath.yuck
      '';
    };
  };
}
