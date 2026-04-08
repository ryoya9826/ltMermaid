# LuaLaTeX + shell-escape（ltmermaid.sty が os.execute で mmdc を呼ぶため）
$pdf_mode = 4;

$lualatex = 'lualatex -interaction=nonstopmode -file-line-error -synctex=1 -shell-escape %O %S';

$recorder = 1;

# mermaid が生成する .mmd / .pdf（必要なら clean で削除）
$clean_ext .= ' mmd pdf';

# 重要: latexmk の「-pdf」は pdflatex 固定のため、この rc の $pdf_mode=4 を上書きします。
# 推奨コマンド:
#   latexmk -pdflua main.tex
# または（-pdf を付けない場合、本 rc の $pdf_mode がそのまま効く環境もある）
1;
