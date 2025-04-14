#!/bin/bash

if [ -z "$1" ]; then
  echo "❌ ファイルパスを指定してください"
  exit 1
fi

FULLPATH="$1"
REPO_ROOT=$(git rev-parse --show-toplevel)
RELATIVE_PATH="${FULLPATH#$REPO_ROOT/}"

FILENAME=$(basename "$FULLPATH")
EXTENSION="${FILENAME##*.}"
BASENAME="${FILENAME%.*}"

mkdir -p tmp exports

PANDIFF="./node_modules/.bin/pandiff"

# pandiff で差分出力
"$PANDIFF" proofread/original_md/"$BASENAME"_original.md proofread/$BASENAME.md \
  -f markdown \
  -t docx \
  -o "exports/${BASENAME}.docx"

"$PANDIFF" proofread/original_md/"$BASENAME"_original.md proofread/$BASENAME.md \
  -f markdown \
  -s \
  -o "exports/SimpleUI/${BASENAME}.html"

echo "✅ 差分ファイル exports/${BASENAME}_diff.docx を生成しました。"
