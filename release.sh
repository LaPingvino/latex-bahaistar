#!/usr/bin/env bash

# Bahá'í Star LaTeX Package - CTAN Release Script
# Creates a proper ZIP package for CTAN submission

set -e  # Exit on any error

# Package information
PACKAGE_NAME="bahaistar"
VERSION="0.1"
DATE=$(date +"%Y-%m-%d")
AUTHOR="Joop Kiefte"

# Directories
BUILD_DIR="ctan-release"
PACKAGE_DIR="$BUILD_DIR/$PACKAGE_NAME"
DIST_DIR="dist"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [[ ! -f "bahaistar.sty" ]]; then
    log_error "bahaistar.sty not found. Please run this script from the project root."
    exit 1
fi

log_info "Starting CTAN release build for $PACKAGE_NAME v$VERSION"

# Clean up previous builds
log_info "Cleaning up previous builds..."
rm -rf "$BUILD_DIR" "$DIST_DIR"
mkdir -p "$PACKAGE_DIR" "$DIST_DIR"

# Copy essential package files
log_info "Copying package files..."
cp bahaistar.sty "$PACKAGE_DIR/"
cp bahaistar.mf "$PACKAGE_DIR/"
cp bahaistar.tfm "$PACKAGE_DIR/"
cp bahaistar.600pk "$PACKAGE_DIR/"
cp bahaistar-example.tex "$PACKAGE_DIR/"
cp LICENSE "$PACKAGE_DIR/"

# Create CTAN-style README
log_info "Creating CTAN README..."
cat > "$PACKAGE_DIR/README" << EOF
BAHÁ'Í STAR - LaTeX Package for Nine-Pointed Star Symbol
========================================================

This package provides the Bahá'í nine-pointed star symbol for LaTeX documents.
The symbol is implemented using METAFONT for high-quality typography and
includes Unicode support for the official Unicode character U+1F7D9 (🟙).

AUTHOR
------
$AUTHOR

LICENSE
-------
MIT License (see LICENSE file for full text)

VERSION
-------
$VERSION ($DATE)

DESCRIPTION
-----------
The bahaistar package provides:
- \bahaistar command for inserting the nine-pointed star symbol
- Automatic Unicode mapping for U+1F7D9 (🟙)
- METAFONT-based high-quality glyph rendering
- Accessibility support with proper ActualText mapping
- Compatible with pdfLaTeX, XeLaTeX, and LuaLaTeX

INSTALLATION
------------
1. Copy bahaistar.sty to your LaTeX tree under tex/latex/bahaistar/
2. Copy bahaistar.mf to your METAFONT tree under fonts/source/public/bahaistar/
3. Copy bahaistar.tfm to your font tree under fonts/tfm/public/bahaistar/
4. If using a precompiled font, copy bahaistar.600pk to fonts/pk/
5. Refresh your TeX filename database (e.g., texhash or mktexlsr)

USAGE
-----
\usepackage{bahaistar}

Then use:
- \bahaistar for the nine-pointed star symbol
- Direct Unicode input: 🟙 (requires XeLaTeX or LuaLaTeX)

EXAMPLE
-------
\documentclass{article}
\usepackage{bahaistar}
\begin{document}
The Bahá'í star: \bahaistar
Unicode: 🟙
\end{document}

FILES
-----
bahaistar.sty     - LaTeX package file
bahaistar.mf       - METAFONT source for the star glyph
bahaistar.tfm      - TeX font metrics file
bahaistar.600pk    - Precompiled bitmap font (600 DPI)
bahaistar-example.tex           - Example document
README             - This file
LICENSE            - MIT license text

REQUIREMENTS
------------
- LaTeX2e
- newunicodechar package
- accsupp package
- METAFONT system (for font generation)

COMPATIBILITY
-------------
Tested with:
- pdfLaTeX ✓
- XeLaTeX
- LuaLaTeX
- TeX Live 2023+
- MiKTeX

CHANGES
-------
v0.1 ($DATE): METAFONT implementation with Unicode support

For more information and updates, see:
https://ctan.org/pkg/bahaistar

CONTACT
-------
For bug reports and feature requests, please contact the author.
EOF

# Create MANIFEST file
log_info "Creating MANIFEST..."
cat > "$PACKAGE_DIR/MANIFEST" << EOF
MANIFEST for bahaistar package ($VERSION)

The following files are included in this distribution:

Documentation:
  README           - Package information and installation instructions
  LICENSE          - MIT License text
  MANIFEST         - This file

Source files:
  bahaistar.sty   - Main LaTeX package file
  bahaistar.mf     - METAFONT source for the star glyph

Font files:
  bahaistar.tfm    - TeX font metrics file
  bahaistar.600pk  - Precompiled bitmap font (600 DPI)

Examples:
  bahaistar-example.tex         - Example document demonstrating usage

Installation directories:
  bahaistar.sty   → tex/latex/bahaistar/
  bahaistar.mf     → fonts/source/public/bahaistar/
  bahaistar.tfm    → fonts/tfm/public/bahaistar/
  bahaistar.600pk  → fonts/pk/public/bahaistar/

Total: $(ls -1 "$PACKAGE_DIR" | wc -l) files
EOF

# Test the package
log_info "Testing the package..."
cd "$PACKAGE_DIR"
if pdflatex bahaistar-example.tex > test_output.log 2>&1; then
    log_success "Package test completed successfully"
    rm -f test.aux test.log test.pdf test_output.log
else
    log_warning "Package test had issues - check manually"
    cat test_output.log
fi
cd - > /dev/null

# Create ZIP file
log_info "Creating ZIP package..."
cd "$BUILD_DIR"
ZIP_NAME="${PACKAGE_NAME}-${VERSION}.zip"

# Check if zip is available, otherwise use tar
if command -v zip >/dev/null 2>&1; then
    zip -r "../$DIST_DIR/$ZIP_NAME" "$PACKAGE_NAME/" > /dev/null
    log_success "ZIP package created: $ZIP_NAME"
else
    log_warning "zip command not found, creating tar.gz instead"
    TAR_NAME="${PACKAGE_NAME}-${VERSION}.tar.gz"
    tar -czf "../$DIST_DIR/$TAR_NAME" "$PACKAGE_NAME/"
    ZIP_NAME="$TAR_NAME"  # Update variable for later use
    log_success "TAR package created: $TAR_NAME"
fi
cd - > /dev/null

# Create TDS-compliant ZIP (TeX Directory Structure)
log_info "Creating TDS-compliant ZIP..."
TDS_DIR="$BUILD_DIR/tds"
mkdir -p "$TDS_DIR"/{tex/latex,fonts/{source,tfm,pk}/public,doc/latex}/"$PACKAGE_NAME"

# Copy files to TDS structure
cp "$PACKAGE_DIR/bahaistar.sty" "$TDS_DIR/tex/latex/$PACKAGE_NAME/"
cp "$PACKAGE_DIR/bahaistar.mf" "$TDS_DIR/fonts/source/public/$PACKAGE_NAME/"
cp "$PACKAGE_DIR/bahaistar.tfm" "$TDS_DIR/fonts/tfm/public/$PACKAGE_NAME/"
cp "$PACKAGE_DIR/bahaistar.600pk" "$TDS_DIR/fonts/pk/public/$PACKAGE_NAME/"
cp "$PACKAGE_DIR"/{README,LICENSE,MANIFEST,bahaistar-example.tex} "$TDS_DIR/doc/latex/$PACKAGE_NAME/"

cd "$BUILD_DIR"
if command -v zip >/dev/null 2>&1; then
    TDS_ZIP_NAME="${PACKAGE_NAME}.tds.zip"
    zip -r "../$DIST_DIR/$TDS_ZIP_NAME" tds/ > /dev/null
    log_success "TDS ZIP package created: $TDS_ZIP_NAME"
else
    log_warning "zip command not found, creating TDS tar.gz instead"
    TDS_ZIP_NAME="${PACKAGE_NAME}.tds.tar.gz"
    tar -czf "../$DIST_DIR/$TDS_ZIP_NAME" tds/
    log_success "TDS TAR package created: $TDS_ZIP_NAME"
fi
cd - > /dev/null

# Generate checksums
log_info "Generating checksums..."
cd "$DIST_DIR"
sha256sum "$ZIP_NAME" > "${ZIP_NAME}.sha256"
sha256sum "$TDS_ZIP_NAME" > "${TDS_ZIP_NAME}.sha256"
cd - > /dev/null

# Summary
log_success "CTAN release package created successfully!"
echo
echo "📦 Release Summary:"
echo "  Package: $PACKAGE_NAME v$VERSION"
echo "  Date: $DATE"
echo "  Author: $AUTHOR"
echo
echo "📁 Generated files:"
echo "  $DIST_DIR/$ZIP_NAME              - Main CTAN submission package"
echo "  $DIST_DIR/$TDS_ZIP_NAME          - TDS-compliant installation package"
echo "  $DIST_DIR/${ZIP_NAME}.sha256     - Checksums for main package"
echo "  $DIST_DIR/${TDS_ZIP_NAME}.sha256 - Checksums for TDS package"
echo
echo "📋 Package contents:"
ls -la "$PACKAGE_DIR"
echo
echo "📏 Package size:"
du -h "$DIST_DIR"/* 2>/dev/null || true
echo
echo "✅ Next steps:"
echo "  1. Test the packages in a clean environment"
echo "  2. Upload $ZIP_NAME to CTAN"
echo "  3. Include the TDS package for easier installation"
if ! command -v zip >/dev/null 2>&1; then
    echo "  4. Note: Created tar.gz files instead of ZIP (zip command not available)"
fi
echo
log_success "Release build complete!"

# Optional: Clean up build directory
read -p "Clean up build directory? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$BUILD_DIR"
    log_info "Build directory cleaned up"
fi
