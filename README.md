# Bahá'í Star LaTeX Package - Quick Start

A minimal LaTeX package for the Bahá'í nine-pointed star symbol 🟙 (U+1F7D9).

## Files Needed

1. `bahaistar.sty` - The package file (see full code below)
2. `bahaistar-example.tex` - Minimal test document

## Minimal Package (`bahaistar.sty`)

```latex
\NeedsTeXFormat{LaTeX2e}
\ProvidesPackage{bahaistar}[2025/09/17 v0.1 Bahá'í nine-pointed star]

\RequirePackage{tikz}
\RequirePackage{newunicodechar}

% Basic star command
\newcommand{\bahaistar}{%
  \begin{tikzpicture}[baseline=-0.15ex, scale=0.4]
    \draw[thick]
      (90:1) -- (70:0.4) -- (50:1) -- (30:0.4) -- (10:1) -- (-10:0.4) -- 
      (-30:1) -- (-50:0.4) -- (-70:1) -- (-90:0.4) -- (-110:1) -- (-130:0.4) -- 
      (-150:1) -- (-170:0.4) -- (170:1) -- (150:0.4) -- (130:1) -- (110:0.4) -- 
      cycle;
  \end{tikzpicture}%
}

% Unicode support
\newunicodechar{🟙}{\bahaistar}

\endinput
```

## Test Document (`bahaistar-example.tex`)

```latex
\documentclass{article}
\usepackage{bahaistar}

\begin{document}

\title{Bahá'í Star Test \bahaistar}
\maketitle

Here is a star: \bahaistar

Unicode input: 🟙

\end{document}
```

## Testing on NixOS

### Option 1: Quick Test with nix-shell

```bash
# Enter a LaTeX environment
nix-shell -p texlive.combined.scheme-medium

# Compile
pdflatex bahaistar-example.tex
```

### Option 2: With flake.nix

Create `flake.nix`:

```nix
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
        ];
      };
    };
}
```

Then:
```bash
nix develop
pdflatex bahaistar-example.tex
```



## Expected Output

The PDF should show:
- Title with a text-sized nine-pointed star (thick outline)
- Text with inline star symbols
- Unicode character rendering as the same star

## Next Steps

If the minimal version works, you can:
1. Add more features from the full package
2. Customize colors and sizes
3. Submit to CTAN

## Troubleshooting

- **Missing tikz**: Install `texlive.combined.scheme-medium` or higher
- **Unicode not working**: Ensure using XeLaTeX or LuaLaTeX for Unicode input
- **Symbol not showing**: Check if font supports U+1F7D9 or use `\bahaistar` command

## License

MIT License - feel free to use, modify, and distribute!
