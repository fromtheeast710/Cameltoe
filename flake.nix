{
  description = "Nix Flake for OCaml development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = { self, nixpkgs, nixgl }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      overlays = [ nixgl.overlay ];
    };

    ocaml-patch =
    { fetchFromGitHub
    , buildDunePackage
    }: buildDunePackage rec {
        pname = "patch";
        version = "2.0.0";
        src = fetchFromGitHub {
          owner = "hannesm";
          repo = "patch";
          rev = "v${version}";
          hash = "sha256-xqcUZaKlbyXF2//MbCom7/pGA2ej6KHYI3rizXwoqTY=";
        };

        minimalOCamlVersion = "5.1.1";
        doCheck = false;
      };

    ocaml-raylib =
    { lib
    , fetchzip
    , buildDunePackage
    , ocamlPackages
    , ocaml
    , libGLU
    , libXi
    , libX11
    , libXcursor
    , libXrandr
    , libXinerama
    }: buildDunePackage rec {
        pname = "raylib";
        version = "1.3.1";
        src = fetchzip {
          url = "https://github.com/tjammer/raylib-ocaml/releases/download/${version}/${pname}-${version}.tbz";
          hash = "sha256-9arAAXDnYVSQa5ACjknXoxLNZsCx61YxAYNMBPtqk5M=";
        };

        buildInputs = [
          libGLU
          libXi
          libX11
          libXrandr
          libXcursor
          libXinerama
        ] ++ (with ocamlPackages; [
          ppx_cstubs
          dune-configurator

          (callPackage ocaml-patch {})
        ]);

        minimalOCamlVersion = "5.1.1";
        doCheck = lib.versionAtLeast ocaml.version minimalOCamlVersion;
      };
  in with pkgs; {
    devShells.${system}.default = mkShell {
      packages = [
        ocaml
        ocamlformat
        libGL
        pkgs.nixgl.nixGLMesa
      ] ++ (with xorg; [
        libX11
      ]) ++ (with ocamlPackages; [
        utop
        ctypes
        dune_3
        ocaml-lsp

        (callPackage ocaml-raylib { })
      ]);
    };};
}
