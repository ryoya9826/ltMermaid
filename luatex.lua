-- LuaTeX-specific l3build configuration for ltMermaid
module = "ltmermaid"
checkengines = {"luatex"}
typesetexe = "lualatex"
checkopts = "-interaction=nonstopmode -halt-on-error"
checkfiles = {
  "test-ltmermaid.tex",
  "test-ltmermaid-env.tex",
  "test-mermaid-env.tex",
  "test-mermaid-luatex.tex",
}
sourcefiles = {"*.sty", "*.tex", "*.mmd", "README.md"}
installfiles = {"*.sty", "README.md"}
docfiles = {"ltmermaid-doc.tex", "mermaid-doc.tex", "ltmermaid-doc-ja.tex", "mermaid-doc-ja.tex"}
