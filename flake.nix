{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nickel.url = "github:tweag/nickel";
  };

  outputs = { self, nixpkgs, flake-utils, nickel }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs {
            inherit system;
          };
          pkgName = "hurl-ncl";
      in {

        packages.${pkgName} = pkgs.stdenv.mkDerivation {
          name = pkgName;
          src = ./.;
          buildInputs = [ pkgs.hurl nickel.defaultPackage.${system} ]; 
          buildPhase = "cat hurl.ncl | nickel typecheck";
          doCheck = true;

          checkPhase =
            ''
              cat ./tests.ncl | nickel export --format toml
              cat ./tests.ncl | nickel export --format yaml
              cat ./tests.ncl | nickel export --format json
            '';

          installPhase =
            ''
              mkdir -p $out
              cp hurl.ncl $out/
            '';
        };

        defaultPackage = self.packages.${system}.${pkgName};

        devShell = pkgs.mkShell { 
          buildInputs = [ pkgs.hurl nickel.defaultPackage.${system} ]; 
        };
      });
}

