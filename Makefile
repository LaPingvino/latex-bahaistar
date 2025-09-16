# Bahá'í Star LaTeX Package Makefile

# Default target
.PHONY: all
all: test

# Compile test document
.PHONY: test
test:
	pdflatex test.tex

# Compile with XeLaTeX (better Unicode support)
.PHONY: test-xe
test-xe:
	xelatex test.tex

# Compile with LuaLaTeX (better Unicode support)
.PHONY: test-lua
test-lua:
	lualatex test.tex

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

# Create package distribution
.PHONY: dist
dist:
	mkdir -p bahai-star
	cp bahai-star.sty bahai-star/
	cp test.tex bahai-star/
	cp README.md bahai-star/
	cp LICENSE bahai-star/ 2>/dev/null || true
	tar -czf bahai-star.tar.gz bahai-star/
	rm -rf bahai-star/

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all        - Build test document (default)"
	@echo "  test       - Compile test.tex with pdflatex"
	@echo "  test-xe    - Compile test.tex with xelatex"
	@echo "  test-lua   - Compile test.tex with lualatex"
	@echo "  view       - Build and open test.pdf"
	@echo "  clean      - Remove auxiliary files"
	@echo "  distclean  - Remove all generated files"
	@echo "  dist       - Create distribution package"
	@echo "  help       - Show this help"
