# Bahá'í Star LaTeX Package Makefile

# Default target
.PHONY: all
all: test

# Compile test document
.PHONY: test
test:
	pdflatex bahaistar-example.tex

# Compile with XeLaTeX (better Unicode support)
.PHONY: test-xe
test-xe:
	xelatex bahaistar-example.tex

# Compile with LuaLaTeX (better Unicode support)
.PHONY: test-lua
test-lua:
	lualatex bahaistar-example.tex

# Open the generated PDF
.PHONY: view
view: test
	xdg-open test.pdf

# Clean auxiliary files
.PHONY: clean
clean:
	rm -f *.aux *.log *.out *.toc *.lot *.lof *.fls *.fdb_latexmk *.synctex.gz

# Clean everything including PDF
.PHONY: distclean
distclean: clean
	rm -f test.pdf

# Create CTAN release package
.PHONY: ctan-release
ctan-release:
	./release.sh

# Legacy distribution target
.PHONY: dist
dist:
	mkdir -p bahaistar
	cp bahaistar.sty bahaistar/
	cp bahaistar-example.tex bahaistar/
	cp README.md bahaistar/
	cp LICENSE bahaistar/ 2>/dev/null || true
	tar -czf bahaistar.tar.gz bahaistar/
	rm -rf bahaistar/

# Release alias
.PHONY: release
release: ctan-release

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all          - Build test document (default)"
	@echo "  test         - Compile bahaistar-example.tex with pdflatex"
	@echo "  test-xe      - Compile bahaistar-example.tex with xelatex"
	@echo "  test-lua     - Compile bahaistar-example.tex with lualatex"
	@echo "  view         - Build and open test.pdf"
	@echo "  clean        - Remove auxiliary files"
	@echo "  distclean    - Remove all generated files"
	@echo "  ctan-release - Create CTAN release package (ZIP)"
	@echo "  release      - Alias for ctan-release"
	@echo "  dist         - Create legacy distribution package"
	@echo "  help         - Show this help"
