#!/bin/bash

# VSCodeから渡されるファイルパス
FULLPATH="$1"
FILENAME=$(basename "$FULLPATH")
BASENAME="${FILENAME%.*}"
EXTENSION="${FILENAME##*.}"

if [ "$EXTENSION" = "docx" ]; then
  pandoc "$FULLPATH" -f docx -t markdown_strict -o "proofread/original_md/${BASENAME}_original.md"
elif [ "$EXTENSION" = "doc" ]; then
  pandoc "$FULLPATH" -f docx -t markdown_strict -o "proofread/original_md/${BASENAME}_original.md"
elif [ "$EXTENSION" = "md" ]; then
  :
else
  pandoc "$FULLPATH" -f markdown+hard_line_breaks -t markdown_strict -o "proofread/original_md/${BASENAME}_original.md"
fi

# 編集用のmdファイルも生成（上書き注意）
cp "proofread/original_md/${BASENAME}_original.md" "proofread/${BASENAME}.md"

echo "✅ ${FILENAME} を Markdown に変換し、編集用ファイルとオリジナルを作成しました。"
