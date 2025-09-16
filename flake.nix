{
  description = "Bahá'í star package test";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system} = {
        ctan-release = pkgs.stdenv.mkDerivation {
          name = "bahai-star-ctan-4.0";
          src = ./.;

          buildInputs = with pkgs; [
            (texlive.combine {
              inherit (texlive) scheme-medium newunicodechar accsupp;
            })
            zip
            gnutar
            gzip
          ];

          buildPhase = ''
            # Test the package first
            pdflatex test.tex

            # Run the release script
            bash release.sh <<< "y"
          '';

          installPhase = ''
            mkdir -p $out
            cp -r dist/* $out/

            # Also include the source files for reference
            mkdir -p $out/src
            cp *.sty *.mf *.tfm *.600pk test.tex LICENSE README.md $out/src/
          '';

          meta = with pkgs.lib; {
            description = "CTAN release package for Bahá'í Star LaTeX package";
            license = licenses.mit;
            maintainers = [ "Joop Kiefte" ];
          };
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          (texlive.combine {
            inherit (texlive) scheme-medium newunicodechar accsupp;
          })
          zip
        ];

        shellHook = ''
          echo "Bahá'í Star LaTeX Package Development Environment"
          echo ""
          echo "Available commands:"
          echo "  make test        - Test the package with pdfLaTeX"
          echo "  make release     - Create CTAN release package"
          echo "  nix build .#ctan-release - Build release with Nix"
          echo ""
        '';
      };
    };
}
