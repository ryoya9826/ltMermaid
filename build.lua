-- l3build configuration for ltMermaid package
module = "ltmermaid"
checkengines = {"pdftex"}
typesetexe = "pdflatex"
checkopts = "-interaction=nonstopmode -halt-on-error"
checkfiles = {
  "test-mermaid-env.tex",
  "test-mermaid-pdftex.tex",
}
sourcefiles = {"*.sty", "*.tex", "*.mmd", "README.md"}
installfiles = {"*.sty", "README.md"}
docfiles = {"ltmermaid-doc.tex", "mermaid-doc.tex", "ltmermaid-doc-ja.tex", "mermaid-doc-ja.tex"}
