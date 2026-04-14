# ltmermaid (LaTeX package)

[Japanese README](README-ja.md)

Embed [Mermaid](https://mermaid.js.org/) diagrams in LaTeX. Diagram sources are written to disk, the [Mermaid CLI](https://github.com/mermaid-js/mermaid-cli) (`mmdc`) renders **vector PDF**, and the result is included with `\includegraphics`. **LuaLaTeX** and **`-shell-escape`** are required. The machine that runs `lualatex` needs **Node.js**, `mmdc` (or **`npx`**), and headless Chromium for the CLI.

**Author:** **Ryoya Ando** — [https://ryoya9826.github.io/](https://ryoya9826.github.io/)  
**License:** [LPPL](https://www.latex-project.org/lppl.txt) version 1.3c  
**Source & issues:** https://github.com/ryoya9826/ltMermaid

---

## Requirements

| Item | Requirement |
|------|-------------|
| TeX engine | **LuaLaTeX** (`lualatex`) |
| LaTeX format | LaTeX2e |
| Shell escape | **`lualatex -shell-escape`** (the package runs the CLI via `os.execute`) |
| External tool | **Mermaid CLI** (`mmdc`) |

If the CLI is missing, `ltmermaid` does **not** install it for you. You can point **`Renderer`** at a command that includes **`npx -y`** (e.g. `npx -y @mermaid-js/mermaid-cli`), in which case `npx` may download packages (**network** may be required). Unless **`Renderer`** names another command, **`mmdc`** must be on `PATH` in the same environment as `lualatex`. Headless Chromium (Puppeteer) is required; see the Mermaid CLI documentation.

---

## Usage

Minimal example:

```latex
\documentclass{article}
% If `mmdc` is not on PATH:
% \usepackage[Renderer={npx -y @mermaid-js/mermaid-cli}]{ltmermaid}
\usepackage{ltmermaid}

\begin{document}
% Optional: cap width at 80\% of line; small diagrams stay natural size
% \MermaidAdjustBoxOpts{max width=0.8\linewidth,center}
% \MermaidAdjustBoxOpts{max width=0.9\linewidth,center,valign=T}

\begin{mermaid}
flowchart LR
  A --> B
\end{mermaid}
\end{document}
```

Compile:

```bash
lualatex -shell-escape yourfile.tex
```

### Renderer and macros

| Mechanism | Purpose |
|-----------|---------|
| `\usepackage[Renderer=...]{ltmermaid}` | Renderer command prefix. If **omitted**, the default is `mmdc`. |
| `\MermaidRendererOptions{...}` | Extra CLI arguments before `-i` / `-o` (merged after the built-in `-f` when pdf-fit is on). |
| `\MermaidNoPdfFit` | Disable **`-f` / `--pdfFit`** for `mmdc` (default is **on**). |
| `\MermaidAdjustBoxOpts{...}` | [adjustbox](https://ctan.org/pkg/adjustbox) keys around `\includegraphics` (default `max width=0.9\linewidth,center`). |
| `\MermaidGraphicsOpts{...}` | Extra keys for `\includegraphics` (e.g. `angle`, `trim`); width is usually set with **`\MermaidAdjustBoxOpts`**. |

### Output files

Intermediate `.mmd` and `.pdf` files are written under **`mermaid/`** relative to the compilation directory. With **`-output-directory`**, they go to **`$TEXMF_OUTPUT_DIRECTORY/mermaid/`**.

Longer explanations and diagram examples: **`sample.tex`** (English) and **`sample-ja.tex`** (Japanese, `bxjsarticle`).

---

## Revision history

- **Version 0.2** (2026-04-13): Removed `MERMAID_MMDC` and `MERMAID_MMDC_OPTIONS`.
- **Version 0.1** (2026-04-08): Initial release. LuaLaTeX, `-shell-escape`, Mermaid CLI PDF embedding, `Renderer` option, related macros, and `-output-directory` support. See the header comments in `ltmermaid.sty` for more detail.

---
