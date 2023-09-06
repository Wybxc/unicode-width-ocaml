{
  description = "Displayed width of Unicode characters and strings";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    crane = {
      url = "github:ipetkov/crane";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { self, nixpkgs, fenix, flake-utils, crane, ... }:
    let
      inherit (nixpkgs.lib) optionals cleanSourceWith;
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        fenixPkgs = fenix.packages.${system};
        pkgs = nixpkgs.legacyPackages.${system};

        toolchain = fenixPkgs.combine [
          fenixPkgs.stable.cargo
          fenixPkgs.stable.clippy
          fenixPkgs.stable.rustc
          fenixPkgs.stable.rustfmt
          fenixPkgs.stable.rust-std
          fenixPkgs.targets.x86_64-unknown-linux-musl.stable.rust-std
        ];
        craneLib = crane.lib.${system}.overrideToolchain toolchain;

        ocamlToolchain = [
          pkgs.ocaml
          pkgs.opam
          pkgs.dune_3
          pkgs.ocamlPackages.ocamlformat
          pkgs.ocamlPackages.ocaml-lsp
          pkgs.ocamlPackages.findlib
          pkgs.ocamlPackages.dune-release
        ];
      in
      let
        commonArgs = {
          src =
            let
              inherit (builtins) match;
              dune = path: _: match ".*dune.*" path != null;
              opam = path: _: match ".*opam$" path != null;
              ocaml = path: _: match ".*mli?$" path != null;
              filter = path: type: craneLib.filterCargoSources path type ||
                dune path type || opam path type || ocaml path type;
            in
            cleanSourceWith {
              src = craneLib.path ./.;
              inherit filter;
            };
          buildInputs = ocamlToolchain ++ optionals pkgs.stdenv.isDarwin [
            pkgs.libiconv
          ];
        };
        cargoArtifacts = craneLib.buildDepsOnly (commonArgs // {
          pname = "unicode-width-deps";
        });
        cargoClippy = craneLib.cargoClippy (commonArgs // {
          inherit cargoArtifacts;
          cargoClippyExtraArgs = "--all-targets -- --deny warnings";
        });
        cargoPackage = craneLib.buildPackage (commonArgs // {
          inherit cargoArtifacts;
          postBuild = ''
            dune build
          '';
        });
      in
      rec {
        packages.default = cargoPackage;
        checks = { inherit cargoPackage cargoClippy; };

        devShells.default = pkgs.mkShell {
          packages = [
            toolchain
            fenixPkgs.rust-analyzer
            pkgs.cargo-expand
            pkgs.cargo-bloat
          ] ++ ocamlToolchain;

          buildInputs = optionals pkgs.stdenv.isDarwin [
            pkgs.darwin.apple_sdk.frameworks.CoreServices
            pkgs.libiconv
          ];

          RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
        };

        devShells.msrv = pkgs.mkShell {
          packages = [
            pkgs.cargo
            pkgs.rustup
            pkgs.cargo-msrv
          ];
        };
      });
}
