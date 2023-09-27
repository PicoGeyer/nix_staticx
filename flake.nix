{
  description = "Python staticx tool";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pypkgs = pkgs.python3Packages;
        staticx = pypkgs.buildPythonPackage rec {
          pname = "staticx";
          version = "0.14.1";
          src = pypkgs.fetchPypi {
            inherit pname version;
            sha256 = "sha256-2/GMEBawvkAA9IAJXtPvM1tRKn2ZK0acsJT7xAkhohg=";
          };
          doCheck = false;
          nativeBuildInputs = [
            pkgs.scons
          ];
          buildInputs = [
            pkgs.glibc.static
          ];
          propagatedBuildInputs = [
            pypkgs.pyelftools
          ];
          patches = [ ./nix_scons.patch ];
        };
        req-packages = p: with p; [
          staticx
        ];
        build-python = pkgs: pkgs.python3.withPackages req-packages;
      in
        {
          packages.default = staticx;
          packages.staticx = staticx;
        }
    );
}
