# ltMermaid (LaTeX package)

[Japanese README](README-ja.md)

Embed [Mermaid](https://mermaid.js.org/) diagrams in LaTeX. The package writes diagram sources to disk, invokes the [Mermaid CLI](https://github.com/mermaid-js/mermaid-cli) (`mmdc`) to render **PDF** (vector), and includes the result with `\includegraphics`. **LuaLaTeX** and **`-shell-escape`** are required. You need an environment where **Node.js**, `mmdc` (or **`npx`**), and Mermaid CLI’s headless Chromium can run.

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
| External tools | **Mermaid CLI** (`mmdc`): e.g. `npm install -g @mermaid-js/mermaid-cli`, or **`npx`** with `@mermaid-js/mermaid-cli` |
| Runtime | **Node.js** / **npm** when using `npx` or a local `npm` install of the CLI |

Headless Chromium (used by Mermaid CLI) must be available; otherwise PDF generation fails.

---

## Packages loaded

The following packages are loaded:

- `ifluatex`, `kvoptions`, `graphicx`, `adjustbox`, `fancyvrb`, `luacode`

---

## Files

| File | Description |
|------|-------------|
| `ltmermaid.sty` | Defines the `mermaid` environment and CLI integration. |

---

## Installation

Install `ltmermaid.sty` in a TDS-compliant tree, for example:

- `$TEXMFHOME/tex/latex/ltmermaid/ltmermaid.sty`  
  or  
- `$TEXMFLOCAL/tex/latex/ltmermaid/ltmermaid.sty`

Refresh the file name database if your TeX tree requires it (`mktexlsr` / `texhash`).

For a single document tree, placing `ltmermaid.sty` next to your `.tex` file is enough.

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

### Renderer and options

| Mechanism | Purpose |
|-----------|---------|
| `\usepackage[Renderer=...]{ltmermaid}` | Renderer command prefix. If **omitted**, the `MERMAID_MMDC` environment variable is used when set; otherwise `mmdc`. Use `Renderer=mmdc` to force `mmdc` and ignore the env. |
| `MERMAID_MMDC` | Environment variable when the `Renderer` package option is not used (defaults to `mmdc` if unset). |
| `\MermaidRendererOptions{...}` | Extra CLI arguments before `-i` / `-o` (merged after the built-in `-f` when pdf-fit is on). |
| `MERMAID_MMDC_OPTIONS` | Same as above, via environment variable. |
| `\MermaidNoPdfFit` | Disable **`-f` / `--pdfFit`** for `mmdc` (default is **on**). To enable pdf-fit again afterwards, use `\makeatletter\def\mermaid@pdffit{-f}\makeatother`. |
| `\MermaidAdjustBoxOpts{...}` | Full [adjustbox](https://ctan.org/pkg/adjustbox) keys around `\includegraphics` (default `max width=0.9\linewidth,center`). |
| `\MermaidGraphicsOpts{...}` | Extra keys for `\includegraphics` (e.g. `angle=90`, `trim=...`); width is usually set with **`\MermaidAdjustBoxOpts`**. |

See `mmdc --help`: **`-s`** changes the Puppeteer scale for sharper raster inside the PDF. **`--pdfFit`** is on by default via **`-f`**; use `\MermaidNoPdfFit` to turn it off.

### Output location

Intermediate `.mmd` and `.pdf` files are written under **`mermaid/`** relative to the compilation directory. With **`-output-directory`**, they go to **`$TEXMF_OUTPUT_DIRECTORY/mermaid/`** (alongside other auxiliary files).

Each run also prints **`[mermaid]`** lines to the **terminal** and **`.log`** (paths, resolved renderer, full shell command, input/output **file sizes in bytes**, **`os.time()` / `os.clock()` timing** for the `os.execute` call, and a **`%PDF`** header check). A non-trivial **output PDF size** and **`%PDF header check: OK`** mean the CLI produced a real file; timing is approximate (`os.clock` often stays small while the subprocess runs).

### Using latexmk

Enable LuaLaTeX and shell escape, for example:

```bash
latexmk -pdflua -shell-escape yourfile.tex
```

If your distribution includes a sample `.latexmkrc`, you can use it as a starting point.

---

## Revision history

- **Version 0.1** (2026-04-08): Initial release. LuaLaTeX, `-shell-escape`, Mermaid CLI PDF embedding, `Renderer` option, related macros, and `-output-directory` support. See the header comments in `ltmermaid.sty` for more detail.

---
