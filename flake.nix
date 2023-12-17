{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [ ];
      });
    in
    {
      devShells = forAllSystems (system: with nixpkgsFor."${system}"; {
        default = mkShell {
          packages = [
            apacheKafka
            gradle
            jdk11
            jdt-language-server
          ];
        };
      });
    };
}
