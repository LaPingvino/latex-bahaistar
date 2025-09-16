{
  description = "Bahá'í star package test";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          texlive.combined.scheme-medium
          fontconfig
          noto-fonts
          fontforge
          python3Packages.fonttools
        ];

        # Make system fonts available and prepare for manual font export
        shellHook = ''
          export FONTCONFIG_PATH=${pkgs.fontconfig.out}/etc/fonts
          fc-cache -fv
          echo "Available Noto fonts:"
          fc-list : family | grep -i noto | head -10
          echo ""
          echo "Ready for manual font export."
          echo "Please export the Bahá'í star glyph (U+1F7D9) from Noto Sans Symbols 2"
          echo "and provide the font file for inclusion in the package."
        '';
      };
    };
}
