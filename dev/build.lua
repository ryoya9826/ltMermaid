-- l3build configuration for ltMermaid package
module = "ltmermaid"
-- パッケージと doc はリポジトリの top にある（この設定は dev/ から実行する）
sourcefiledir = ".."
docfiledir = ".."
checkengines = {"pdftex"}
typesetexe = "pdflatex"
checkopts = "-interaction=nonstopmode -halt-on-error"
checkfiles = {
  "test-mermaid-env.tex",
  "test-mermaid-pdftex.tex",
}
sourcefiles = {"*.sty", "*.tex", "README.md"}
installfiles = {"*.sty", "README.md"}
docfiles = {"ltmermaid-doc.tex", "mermaid-doc.tex", "ltmermaid-doc-ja.tex", "mermaid-doc-ja.tex"}
