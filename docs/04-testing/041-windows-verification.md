# Windows での動作検証手順

この文書は、`mermaid.sty` と `ltmermaid.sty` が Windows で動くかを確かめるための手順書です。新しい版を出す前の確認や、まだ試していない環境（MiKTeX など）での確認に使います。Windows の PC で Claude などの AI エージェントに読ませ、検証から結果の報告までを任せることを想定しています。

## この文書を読んだエージェントへ

- 目的は **Windows で動くかを確かめて、結果を報告すること** です。パッケージのコードは直さないでください。直す場合は、報告を受けた人が改めて指示します。
- commit、push、Issue や PR への投稿はしないでください。git の操作はリポジトリの管理者が自分で行います。
- 検証は、リポジトリの外に作る作業用フォルダで行います。リポジトリの中にファイルを作らないでください。
- 結果は「[結果の報告](#結果の報告)」の形式でまとめてください。失敗したときは、推測で終わらせず、ログやエラーメッセージを引用してください。

## 前提

v1.2 で Windows に対応しました。2026-10-23 に、次の環境で「[検証する組み合わせ](#検証する組み合わせ)」のすべてが合格しています。

| 項目 | Windows | macOS |
|---|---|---|
| OS | Windows 11 Pro 10.0.26300 | macOS |
| TeX | TeX Live 2026 | TeX Live 2026 |
| Mermaid CLI | 11.12.0、12.0.0 | 11.17.0、12.0.0 |
| その他 | Node.js v24.14.1、PowerShell 7.4.21、`core.autocrlf` は `true` | — |

**MiKTeX はまだ試していません。**

2つのパッケージは、外部コマンドの呼び出し方が違います。

| パッケージ | エンジン | 外部コマンドの呼び出し方 |
|---|---|---|
| `mermaid.sty` | pdfLaTeX、XeLaTeX、LuaLaTeX、upLaTeX など | `\ShellEscape` と `\write18` でシェルにコマンド文字列を渡す |
| `ltmermaid.sty` | LuaLaTeX だけ | Lua の `os.execute` と `io.popen` でコマンド文字列を渡す |

## Windows で気をつける点

v1.2 の検証で分かったことです。変更を加えたときは、ここに挙げた点が崩れていないかを確かめてください。

### コマンドは `cmd.exe` が実行する

- TeX Live の Windows 版では、`\write18` と `os.execute` のコマンドを `cmd.exe` が実行します。`cmd.exe` は `;`、`[ ]`、`$VAR`、`if … fi` といった POSIX シェルの文法を解釈しません。v1.1 の `mermaid.sty` は、このためにまったく動きませんでした。
- v1.2 の `mermaid.sty` がシェルに渡すコマンドは、`sh` と `cmd.exe` で同じ意味になる書き方（`"…"` で囲んだパスと、`>`、`>>`、`2>` のリダイレクト）だけです。OS によって書き方を分けているのは、`mermaid/` を作る `mkdir` だけです。シェルに渡すコマンドを変えたときは、Windows で必ず確かめてください。

### シングルクォートの置き換え

- TeX Live の Windows 版は、`os.execute` と `\write18` のコマンドに含まれる `'` を `"` に置き換えてから `cmd.exe` に渡します。`io.popen` では置き換えません。
- ダブルクォートの中の `'` も置き換わるため、**`'` を含むパスは使えません**。パッケージの側では避けられない制限なので、README と doc に書いてあります。
- `ltmermaid.sty` は、Windows ではパスを `"…"` で囲みます（`shq()`）。

### `mermaid.sty` が使う外部コマンド

| コマンド | 用途 | MiKTeX で確かめること |
|---|---|---|
| `kpsewhich -var-value=TEXMF_OUTPUT_DIRECTORY` | 出力ディレクトリを調べる | `-output-directory` を指定したとき、`TEXMF_OUTPUT_DIRECTORY` が設定されるか |
| `texlua` | 作業ディレクトリを調べる（`cmd.exe` の `cd` は日本語のパスを UTF-8 で出力しないため） | `texlua` があるか |
| `extractbb` | DVI 出力と XeTeX で、`-output-directory` を指定したときの図の大きさを調べる | `extractbb` があるか |

### 環境の違い

| 項目 | 確かめること |
|---|---|
| 日本語を含むパス | コマンドの文字コードが崩れないか（TeX Live 2026 では問題なし） |
| 空白を含むパス | 引数が分断されないか（TeX Live 2026 では問題なし） |
| `mmdc` の実体 | npm で入れた `mmdc` は `mmdc.cmd` になる。`mmdc` という名前で呼び出せるか |
| Chrome | Mermaid CLI が使う Chrome（puppeteer）が入っているか。版が合わないと描画に失敗する |
| 改行コード | git の `core.autocrlf` により `.sty` などが CRLF になっても動くか（`true` で問題なし） |

## 環境の準備

次のものを用意します。

| 項目 | 内容 |
|---|---|
| TeX | TeX Live 2026 か MiKTeX（できれば両方） |
| Node.js | LTS 版 |
| Mermaid CLI | 11 系と 12 系。グローバルには片方だけ入れ、もう片方は `npx` で呼ぶ |
| Chrome | Mermaid CLI に合う版の `chrome-headless-shell` |
| シェル | PowerShell（検証スクリプトの実行に使う） |

### 準備の手順

1. Mermaid CLI 11 を入れます。

   ```powershell
   npm install -g @mermaid-js/mermaid-cli@11
   ```

2. `mmdc` 単体で描画できるか確かめます。`Could not find Chrome` と出た場合は、エラーに書かれた版の `chrome-headless-shell` を入れます。版の番号はエラーメッセージに出ます（例：`148.0.7778.97`）。

   ```powershell
   mmdc -i diagram-001.mmd -o "$env:TEMP\mmdc-check.pdf"
   ```

   ```powershell
   npx -y puppeteer browsers install chrome-headless-shell@<エラーに出た版>
   ```

3. Mermaid CLI 12 が `npx` で動くか確かめます。

   ```powershell
   npx -y @mermaid-js/mermaid-cli@12 --version
   ```

4. 環境の情報を記録します。結果を報告するときに使います。

   ```powershell
   $PSVersionTable.PSVersion; lualatex --version | Select-Object -First 1; mmdc --version; where.exe mmdc; node --version; git config core.autocrlf
   ```

## 検証の方法

検証スクリプトは、テスト用の文書を作業用フォルダに作り、エンジンごとに2回ずつコンパイルして結果を表にします。テスト用の文書には、`mermaid` 環境2つと `\mermaidfile` 1つが入っています。

### 検証する組み合わせ

| 観点 | 値 |
|---|---|
| パッケージとエンジン | `mermaid` × pdflatex、xelatex、lualatex、latex＋dvipdfmx、uplatex＋dvipdfmx／`ltmermaid` × lualatex |
| 出力先 | 作業ディレクトリ／`-output-directory=out` |
| フォルダ名 | `w`（英数字だけ）／`my dir_x`（空白と `_` を含む）／`日本語`（日本語を含む） |
| Mermaid CLI | 11（`mmdc`）／12（`npx -y @mermaid-js/mermaid-cli@12`）。スクリプトの `-Renderer` で切り替える |

### 検証スクリプト

次の内容を、リポジトリの外（例：`C:\ltmermaid-verify\verify-windows.ps1`）に保存します。

- Windows PowerShell 5.1 で実行する場合は、**BOM 付きの UTF-8** で保存してください。BOM が無いと Shift_JIS として読まれ、`日本語` のフォルダ名などが文字化けします。PowerShell 7 なら BOM は不要です。
- スクリプト自体の誤り（構文エラー、パスの書き方など）で動かない場合は、スクリプトを直してかまいません。直したところは報告に含めてください。

```powershell
# ltmermaid の Windows 検証スクリプト
# 使い方:
#   powershell -ExecutionPolicy Bypass -File C:\ltmermaid-verify\verify-windows.ps1 -Repo <リポジトリのパス>
#   powershell -ExecutionPolicy Bypass -File C:\ltmermaid-verify\verify-windows.ps1 -Repo <リポジトリのパス> -Renderer "npx -y @mermaid-js/mermaid-cli@12"
param(
  [Parameter(Mandatory = $true)][string]$Repo,
  [string]$Renderer = "mmdc",
  [string]$WorkRoot = "C:\ltmermaid-verify\runs"
)
$ErrorActionPreference = "Continue"
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$Work = Join-Path $WorkRoot $Stamp
New-Item -ItemType Directory -Path $Work -Force | Out-Null
$Results = @()

function New-TestDoc([string]$Dir, [string]$Pkg, [bool]$Dvi) {
  $class = if ($Dvi) { "\documentclass[dvipdfmx]{article}" } else { "\documentclass{article}" }
  $doc = @"
$class
\usepackage[Renderer={$Renderer}]{$Pkg}
\begin{document}
\begin{mermaid}
graph LR
  A --> B
\end{mermaid}
\mermaidfile{diagram-001.mmd}
\begin{mermaid}[width=3cm]
graph LR
  C --> D
\end{mermaid}
\end{document}
"@
  # TeX が読めるよう、BOM なしの UTF-8 で書き出す
  [System.IO.File]::WriteAllText((Join-Path $Dir "t.tex"), $doc, (New-Object System.Text.UTF8Encoding $false))
  Copy-Item (Join-Path $Repo "diagram-001.mmd"), (Join-Path $Repo "mermaid.sty"), (Join-Path $Repo "ltmermaid.sty") $Dir
}

function Invoke-Case([string]$Pkg, [string]$Engine, [bool]$UseOutDir, [string]$DirName) {
  $dvi = ($Engine -eq "latex") -or ($Engine -eq "uplatex")
  $label = "{0}/{1}/{2}/{3}" -f $Pkg, $Engine, $(if ($UseOutDir) { "outdir" } else { "plain" }), $DirName
  $dir = Join-Path (Join-Path $Work ("{0}-{1}-{2}" -f $Pkg, $Engine, $(if ($UseOutDir) { "outdir" } else { "plain" }))) $DirName
  New-Item -ItemType Directory -Path $dir -Force | Out-Null
  New-TestDoc $dir $Pkg $dvi
  $od = "."
  $texArgs = @("-shell-escape", "-interaction=nonstopmode", "-halt-on-error")
  if ($UseOutDir) {
    $od = "out"
    New-Item -ItemType Directory -Path (Join-Path $dir $od) -Force | Out-Null
    $texArgs += "-output-directory=out"
  }
  $texArgs += "t.tex"
  $exit = @(); $hash = @()
  Push-Location $dir
  try {
    foreach ($i in 1, 2) {
      & $Engine @texArgs *> "run$i.txt"
      $code = $LASTEXITCODE
      if ($dvi -and $code -eq 0) {
        & dvipdfmx -o "$od\t.pdf" "$od\t.dvi" *> "dvipdfmx$i.txt"
        $code = $LASTEXITCODE
      }
      $exit += $code
      $fig = Join-Path $od "mermaid\t-mermaid-1.pdf"
      $hash += $(if (Test-Path $fig) { (Get-FileHash $fig).Hash } else { "" })
    }
    $figCount = @(Get-ChildItem (Join-Path $od "mermaid") -Filter "t-mermaid-*.pdf" -ErrorAction SilentlyContinue).Count
    # 2回目のコンパイルで再描画を省いたか（ltmermaid は t.log、mermaid は *.out に記録される）
    # mermaid\ が無いケースでも止まらないよう，存在するファイルだけを渡す
    $skipFiles = @(Join-Path $od "t.log" | Where-Object { Test-Path -LiteralPath $_ }) +
      @(Get-ChildItem (Join-Path $od "mermaid") -Filter "*.out" -ErrorAction SilentlyContinue | ForEach-Object FullName)
    $skipLog = if ($skipFiles.Count -gt 0) { Select-String -LiteralPath $skipFiles -Pattern "renderer skipped" -SimpleMatch } else { $null }
    $script:Results += [pscustomobject]@{
      Case       = $label
      Run1       = $exit[0]
      Run2       = $exit[1]
      Figures    = $figCount
      BodyPdf    = Test-Path (Join-Path $od "t.pdf")
      Skipped2nd = [bool]$skipLog
      PdfStable  = ($hash[0] -ne "") -and ($hash[0] -eq $hash[1])
      StrayDir   = $UseOutDir -and (Test-Path (Join-Path $dir "mermaid"))
      Dir        = $dir
    }
  } finally {
    Pop-Location
  }
}

foreach ($name in "w", "my dir_x", "日本語") {
  foreach ($outdir in $false, $true) {
    foreach ($engine in "pdflatex", "xelatex", "lualatex", "latex", "uplatex") {
      Invoke-Case "mermaid" $engine $outdir $name
    }
    Invoke-Case "ltmermaid" "lualatex" $outdir $name
  }
}

$Results | Format-Table Case, Run1, Run2, Figures, BodyPdf, Skipped2nd, PdfStable, StrayDir -AutoSize
$Results | Export-Csv -Path (Join-Path $Work "results.csv") -NoTypeInformation -Encoding UTF8
"結果の CSV: " + (Join-Path $Work "results.csv")
```

### 合否の判定基準

各行が次の条件をすべて満たせば合格です。

| 列 | 合格の条件 | 意味 |
|---|---|---|
| `Run1`、`Run2` | どちらも `0` | 1回目と2回目のコンパイルがエラーなく終わった |
| `Figures` | `3` | 図が3つ（環境2つと `\mermaidfile` 1つ）描画された |
| `BodyPdf` | `True` | 本文の PDF ができた |
| `Skipped2nd` | `True` | 2回目は、図を描画し直さなかった |
| `PdfStable` | `True` | 2回目の後も、図の PDF が1回目と同じ内容だった |
| `StrayDir` | `False` | `-output-directory` を指定したとき、作業ディレクトリに `mermaid\` ができなかった |

`-f` の付け方も確かめます。どれか1つのケースで、次のログを見てください。Mermaid CLI 11 なら `-f` が付き、12 なら付かないのが正しい動作です。

- `ltmermaid`：`t.log` の `[ltmermaid] pdf-fit:` の行
- `mermaid`：`mermaid\t-mermaid-1.out` の `pdf-fit: auto ->` の行

## 失敗したときに集める情報

失敗したケースの `Dir` 列のフォルダから、次のものを集めてください。

| ファイル | 内容 |
|---|---|
| `run1.txt` | 1回目のコンパイルの画面出力 |
| `t.log`（`-output-directory` のときは `out\t.log`） | `[mermaid]` または `[ltmermaid]` で始まる行と、`!` で始まるエラー |
| `mermaid\*.err`、`mermaid\*.out`（`mermaid.sty` だけ） | シェルと `mmdc` のエラー出力 |
| `mermaid\` フォルダの一覧 | どのファイルができて、どれができなかったか |
| 作業ディレクトリの一覧 | `-p` や `$N` などの不要なフォルダやファイルができていないか |

`mermaid.sty` のログには `full shell command:` の行があり、シェルに渡したコマンドがそのまま記録されています。`cmd.exe` でどこが通らなかったかを調べるときに使ってください。

## 結果の報告

次の形式でまとめてください。

1. **環境**：Windows の版、TeX Live と MiKTeX のどちらか（とその版）、Node.js と Mermaid CLI の版、PowerShell の版、`core.autocrlf` の値
2. **結果の表**：検証スクリプトが出力した表を、Mermaid CLI 11 と 12 の両方について貼る
3. **気をつける点ごとの結論**：「[Windows で気をつける点](#windows-で気をつける点)」の各項目について、問題が無かったか
4. **失敗の原因**：失敗したケースごとに、原因と根拠（ログの引用）
5. **対応の案**：考えられる直し方。ただしコードは直さない

対応の案を書くときは、シェルに渡すコマンドが `sh` と `cmd.exe` の両方で同じ意味になるかを必ず確かめてください。
