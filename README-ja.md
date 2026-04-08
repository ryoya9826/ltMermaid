# ltMermaid（LaTeX パッケージ）

[English README](README.md)

[Mermaid](https://mermaid.js.org/) の図を LaTeX に埋め込みます。図のソースをディスクに書き出し、[Mermaid CLI](https://github.com/mermaid-js/mermaid-cli)（`mmdc`）で **PDF（ベクター）** を生成し、`\includegraphics` で取り込みます。**LuaLaTeX** と **`-shell-escape`** が必要です。Node.js、`mmdc`（または `npx`）を利用できる環境を想定しています。

**作者:** **Ryoya Ando** — [https://ryoya9826.github.io/](https://ryoya9826.github.io/)  
**ライセンス:** [LPPL](https://www.latex-project.org/lppl.txt) バージョン 1.3c  
**ソース・報告:** https://github.com/ryoya9826/ltMermaid

---

## 動作条件

| 項目 | 要件 |
|------|------|
| TeX エンジン | **LuaLaTeX**（`lualatex`） |
| LaTeX 形式 | LaTeX2e |
| シェルエスケープ | **`lualatex -shell-escape`**（CLI を `os.execute` で起動するため） |
| 外部ツール | **Mermaid CLI**（`mmdc`）。例: `npm install -g @mermaid-js/mermaid-cli`、または **`npx`** で `@mermaid-js/mermaid-cli` |
| ランタイム | `npx` 利用時、または CLI を npm で入れた場合は **Node.js** / **npm** |

Mermaid CLI が依存するヘッドレス Chromium が使えないと、PDF は生成されません。

---

## 読み込まれる LaTeX パッケージ

次のパッケージを読み込みます。

- `ifluatex`, `kvoptions`, `graphicx`, `adjustbox`, `fancyvrb`, `luacode`

---

## 同梱ファイル

| ファイル | 内容 |
|----------|------|
| `ltmermaid.sty` | `mermaid` 環境と CLI 連携の定義 |

---

## インストール

`ltmermaid.sty` を TDS に沿ったツリーに置きます。例:

- `$TEXMFHOME/tex/latex/ltmermaid/ltmermaid.sty`  
  または  
- `$TEXMFLOCAL/tex/latex/ltmermaid/ltmermaid.sty`

必要に応じてファイル名データベースを更新してください（`mktexlsr` / `texhash`）。

単一の原稿だけで使う場合は、`.tex` と同じディレクトリに `ltmermaid.sty` を置いても構いません。

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

### レンダラとオプション

| 指定方法 | 役割 |
|----------|------|
| `\usepackage[Renderer=...]{ltmermaid}` | レンダラのコマンド行の先頭。**省略**時は環境変数 `MERMAID_MMDC` があればそれを使い、なければ `mmdc`。環境を無視して `mmdc` 固定にするには `Renderer=mmdc`。 |
| `MERMAID_MMDC` | パッケージオプション `Renderer` を付けないときに使う環境変数（未設定時は `mmdc` を想定）。 |
| `\MermaidRendererOptions{...}` | CLI に渡す追加引数（`-i` / `-o` の前。既定の `-f` の後に連結）。 |
| `MERMAID_MMDC_OPTIONS` | 上記と同じ内容を環境変数で渡す場合。 |
| `\MermaidNoPdfFit` | `mmdc` の **`-f`（--pdfFit）** を付けない（既定は **付ける**）。一度オフにしたあと再度有効にするには `\makeatletter\def\mermaid@pdffit{-f}\makeatother`。 |
| `\MermaidAdjustBoxOpts{...}` | `\includegraphics` を包む [adjustbox](https://ctan.org/pkg/adjustbox) のキー（既定は `max width=0.9\linewidth,center`）。 |
| `\MermaidGraphicsOpts{...}` | `\includegraphics` 用の追加キー（`angle` や `trim` など）。幅は通常 **`\MermaidAdjustBoxOpts`** で調整。 |

`mmdc --help` 参照: **`-s`** は描画スケール。**`-f` / --pdfFit** は本パッケージの既定で有効。無効にする場合は `\MermaidNoPdfFit`。

### 出力の場所

中間の `.mmd` と `.pdf` は、コンパイル時の作業ディレクトリから見た **`mermaid/`** 以下に出力されます。**`-output-directory`** を使う場合は、**`$TEXMF_OUTPUT_DIRECTORY/mermaid/`**（他の補助ファイルと同じ側）に置かれます。

各図の処理ごとに、**ターミナル**と **`.log`** に **`[mermaid]`** で始まる行が出ます（パス、解決後のレンダラ、実際のシェルコマンド、入出力ファイルの**バイトサイズ**、`os.execute` 前後の **`os.time()` / `os.clock()`**、`%PDF` ヘッダ確認など）。**出力 PDF のバイト数**と **`%PDF header check: OK`** で CLI が実際に PDF を書いたことを確認できます。タイミング表示は目安です（子プロセス待ち中は `os.clock` がほとんど増えないことがあります）。

### latexmk での例

LuaLaTeX とシェルエスケープを有効にします。

```bash
latexmk -pdflua -shell-escape yourfile.tex
```

配布物に `.latexmkrc` のサンプルが含まれている場合は、それを参考にできます。

---

## 改訂履歴

- **Version 0.1**（2026-04-08）: 初回リリース。LuaLaTeX・`-shell-escape`・Mermaid CLI による PDF 埋め込み、`Renderer` オプションと各種設定マクロ、`-output-directory` 対応。詳細は `ltmermaid.sty` 先頭のコメントも参照。

---
