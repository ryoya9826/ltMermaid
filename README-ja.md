# ltmermaid（LaTeX パッケージ）

[English README](README.md)

[Mermaid](https://mermaid.js.org/) の図を LaTeX に埋め込みます。図のソースをディスクに書き出し、[Mermaid CLI](https://github.com/mermaid-js/mermaid-cli)（`mmdc`）で **PDF（ベクター）** を生成し、`\includegraphics` で取り込みます。**LuaLaTeX** と `**-shell-escape`** が必要です。`lualatex` を動かすマシンには **Node.js**、`mmdc`（または `**npx`**）、および CLI 用のヘッドレス Chromium が必要です。

**作者:** **Ryoya Ando** — [https://ryoya9826.github.io/](https://ryoya9826.github.io/)  
**ライセンス:** [LPPL](https://www.latex-project.org/lppl.txt) バージョン 1.3c  
**ソース・報告:** [https://github.com/ryoya9826/ltMermaid](https://github.com/ryoya9826/ltMermaid)

---

## 動作条件


| 項目       | 要件                                                       |
| -------- | -------------------------------------------------------- |
| TeX エンジン | **LuaLaTeX**（`lualatex`）                                 |
| LaTeX 形式 | LaTeX2e                                                  |
| シェルエスケープ | `**lualatex -shell-escape`**（CLI を `os.execute` で起動するため） |
| 外部ツール    | **Mermaid CLI**（`mmdc`）                                  |


環境にCLI が無い場合、`ltmermaid` が**自動でインストールすることはありません**。`**Renderer`** に `**npx -y**` を含むコマンド（例: `npx -y @mermaid-js/mermaid-cli`）を渡すと、`npx` がパッケージを取得する場合があります。`Renderer` で別コマンドを指さない限り `**mmdc**` が `lualatex` と同じ環境の `PATH` から見える必要があります。ヘッドレス Chromium（Puppeteer）が必要です。詳細は Mermaid CLI のドキュメントを参照してください。

---

## 使い方

最小例:

```latex
\documentclass{article}
% PATH に mmdc が無い場合の例:
% \usepackage[Renderer={npx -y @mermaid-js/mermaid-cli}]{ltmermaid}
\usepackage{ltmermaid}

\begin{document}
% 任意: 行幅の 80\% を上限に縮小（小さい図は拡大しない）
% \MermaidAdjustBoxOpts{max width=0.8\linewidth,center}
% \MermaidAdjustBoxOpts{max width=0.9\linewidth,center,valign=T}

\begin{mermaid}
flowchart LR
  A --> B
\end{mermaid}
\end{document}
```

コンパイル:

```bash
lualatex -shell-escape yourfile.tex
```

### レンダラとマクロ


| 指定方法                                   | 役割                                                                                                            |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `\usepackage[Renderer=...]{ltmermaid}` | レンダラのコマンド行の先頭。**省略**時は既定で `mmdc`。                                                                             |
| `\MermaidRendererOptions{...}`         | CLI に渡す追加引数（`-i` / `-o` の前。既定の `-f` の後に連結）。                                                                   |
| `\MermaidNoPdfFit`                     | `mmdc` の `**-f`（--pdfFit）** を付けない（既定は **付ける**）。                                                               |
| `\MermaidAdjustBoxOpts{...}`           | `\includegraphics` を包む [adjustbox](https://ctan.org/pkg/adjustbox) のキー（既定は `max width=0.9\linewidth,center`）。 |
| `\MermaidGraphicsOpts{...}`            | `\includegraphics` 用の追加キー（`angle` や `trim` など）。幅は通常 `**\MermaidAdjustBoxOpts`** で調整。                          |


### 出力ファイル

中間の `.mmd` と `.pdf` は、コンパイル時の作業ディレクトリから見た `**mermaid/**` 以下に出力されます。`**-output-directory**` を使う場合は、`**$TEXMF_OUTPUT_DIRECTORY/mermaid/**` に置かれます。

説明と図の例の全文は `**sample.tex**`（英語）と `**sample-ja.tex**`（日本語、`bxjsarticle`）を参照してください。

---

## 改訂履歴

- **Version 0.2**（2026-04-13）: `MERMAID_MMDC` / `MERMAID_MMDC_OPTIONS` を廃止。
- **Version 0.1**（2026-04-08）: 初回リリース。LuaLaTeX・`-shell-escape`・Mermaid CLI による PDF 埋め込み、`Renderer` オプションと各種設定マクロ、`-output-directory` 対応。詳細は `ltmermaid.sty` 先頭のコメントも参照。

---

