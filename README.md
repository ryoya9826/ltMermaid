# LaTeX Packages to Embed Mermaid Diagrams (`mermaid` / `ltmermaid`)

Embed [Mermaid](https://mermaid.js.org/) diagrams in LaTeX. Diagram sources are written to disk, and the [Mermaid CLI](https://github.com/mermaid-js/mermaid-cli) (`mmdc`) renders vector PDFs, which are then included using `\includegraphics`.

Originally, `ltmermaid` was created exclusively for LuaLaTeX. Subsequently, the `mermaid` package was developed as a LuaTeX-independent version to support other engines. Therefore, there are two packages provided in this repository:

- `mermaid.sty` (`mermaid`)  
The implementation to be used with pdfLaTeX / XeLaTeX / upLaTeX / LuaLaTeX, etc. It invokes the Mermaid CLI via the `shellesc` package (or directly via `\write18`). No Lua interpreter is required.
- `ltmermaid.sty` (`ltmermaid`)  
An implementation dedicated to LuaLaTeX that provides the same macros (the `Renderer` option, `\Mermaid...` macros, and the `mermaid` environment) as the `mermaid` package above. The CLI is invoked via Lua's `os.execute`, and the package handles LuaLaTeX-specific behavior such as outputting to `mermaid/` under `-output-directory` / `TEXMF_OUTPUT_DIRECTORY`.

Both packages can be chosen when using `lualatex`. The distinction is that you use `mermaid` when you want to use Mermaid with an engine other than Lua, and `ltmermaid` when you prefer a LuaLaTeX-native implementation and output-directory coordination.

Author: Ryoya Ando — [https://ryoya9826.github.io/](https://ryoya9826.github.io/)  
License: [LPPL](https://www.latex-project.org/lppl.txt) version 1.3c  
Source & issues: [https://github.com/ryoya9826/ltMermaid](https://github.com/ryoya9826/ltMermaid)

---

## Requirements (`mermaid`)

| Item             | Requirement                                                                      |
| ---------------- | -------------------------------------------------------------------------------- |
| TeX engine       | upLaTeX / pdfLaTeX / LuaLaTeX, etc. (Lua interpreter is not required)            |
| LaTeX format     | LaTeX2e                                                                          |
| Shell escape     | `-shell-escape` (the CLI is invoked via `shellesc` / `\write18`)                 |
| External tool    | Mermaid CLI (`mmdc`)                                                             |

If the CLI is missing in the environment, this package does not install it automatically. If you pass a command containing `npx -y` (e.g., `npx -y @mermaid-js/mermaid-cli`) to `Renderer`, `npx` may download the package. Unless another command is specified via `Renderer`, `mmdc` must be on the `PATH` in the compilation environment. Headless Chromium (Puppeteer) is required. Please refer to the Mermaid CLI documentation for details.

### For `ltmermaid`

The following points differ from `mermaid`:

| Item             | Requirement                                                  |
| ---------------- | ------------------------------------------------------------ |
| TeX engine       | LuaLaTeX (`lualatex`) only                                   |
| Shell escape     | `lualatex -shell-escape` (the CLI is invoked via `os.execute`) |

As stated above, the engine is limited to LuaLaTeX. In other respects, the handling of external tools and `Renderer` / `npx` is identical to `mermaid`.

---

## Usage (Minimal Example)

### For `mermaid`

```latex
\documentclass{article}
% Example if `mmdc` is not on PATH:
% \usepackage[Renderer={npx -y @mermaid-js/mermaid-cli}]{mermaid}
\usepackage{mermaid}

\begin{document}
% Optional: cap width at 80\% of line; small diagrams aren't scaled up
% \MermaidAdjustBoxOpts{max width=0.8\linewidth,center}
% \MermaidAdjustBoxOpts{max width=0.9\linewidth,center,valign=T}

\begin{mermaid}
flowchart LR
  A --> B
\end{mermaid}
\end{document}
```

Compilation examples:

```bash
pdflatex -shell-escape yourfile.tex
xelatex  -shell-escape yourfile.tex
lualatex -shell-escape yourfile.tex
uplatex -shell-escape yourfile.tex && dvipdfmx yourfile.dvi
```

### For `ltmermaid`

Change the package name to `ltmermaid` (the `mermaid` environment in the body remains the same).

```latex
\documentclass{article}
% \usepackage[Renderer={npx -y @mermaid-js/mermaid-cli}]{ltmermaid}
\usepackage{ltmermaid}

\begin{document}
\begin{mermaid}
flowchart LR
  A --> B
\end{mermaid}
\end{document}
```

Compilation is only possible with LuaLaTeX:

```bash
lualatex -shell-escape yourfile.tex
```

---

### Renderer and Macros

Whether using `mermaid` or `ltmermaid`, the following specification methods are the same (just substitute the package name in `\usepackage`).

| Mechanism                                   | Purpose                                                                                                                              |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `\usepackage[Renderer=...]{mermaid}`, etc.  | The prefix of the execution command line. The default is `mmdc` if omitted.                                                          |
| `\MermaidRendererOptions{...}`              | Extra CLI arguments passed before `-i` / `-o` (merged after the default `-f`).                                                       |
| `\MermaidNoPdfFit`                          | Disables the `-f` (`--pdfFit`) option for `mmdc` (default is enabled).                                                               |
| `\MermaidAdjustBoxOpts{...}`                | Additional options for the [adjustbox](https://ctan.org/pkg/adjustbox) environment used for diagram placement (default is `max width=0.9\linewidth,center`). |
| `\MermaidGraphicsOpts{...}`                 | Extra options passed to `\includegraphics` (e.g. `angle` or `trim`). The width is typically adjusted with `\MermaidAdjustBoxOpts`.   |

---

### Output Files

#### For `mermaid`

Intermediate `.mmd` and `.pdf` files are output to the `mermaid/` directory right under the compilation directory. The file names will be a concatenation of the job name and a sequential number, such as `\jobname-mermaid-1.mmd`. This does not follow `-output-directory` / `TEXMF_OUTPUT_DIRECTORY`.

#### For `ltmermaid`

They are basically output to `mermaid/` in the same way, but when `-output-directory` is used, they are placed in `$TEXMF_OUTPUT_DIRECTORY/mermaid/`.

For full explanations and diagram examples, see `mermaid-sample.tex` / `mermaid-sample-ja.tex` (`mermaid`) and `ltmermaid-sample.tex` / `ltmermaid-sample-ja.tex` (`ltmermaid`).

---

## Revision History

### `mermaid.sty`

- Version 1.0 (2026-04-16): Stable release.

### `ltmermaid.sty`

- Version 1.0 (2026-04-16): Stable release.
- Version 0.2 (2026-04-13): Removed `MERMAID_MMDC` and `MERMAID_MMDC_OPTIONS`.
- Version 0.1 (2026-04-08): Initial release.

---
