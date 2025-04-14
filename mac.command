#!/bin/bash

set -e
WORK_DIR="$HOME/Downloads/setup_tools"
REPO_DIR="$(cd "$(dirname "$0")"; pwd)"

mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

############################################
# 1. VSCode インストール
############################################
if [ -d "/Applications/Visual Studio Code.app" ]; then
    echo "✅ VSCode はすでにインストールされています"
else
    echo "📦 VSCode をダウンロード中..."
    curl -L -o vscode.zip "https://update.code.visualstudio.com/latest/darwin/stable"
    unzip -q vscode.zip
    sudo mv -f "Visual Studio Code.app" /Applications/
    echo "✅ VSCode をインストールしました"
fi

############################################
# 2. Node.js インストール
############################################
if command -v node >/dev/null 2>&1; then
    echo "✅ Node.js はすでにインストールされています"
else
    echo "📦 Node.js をダウンロード中..."
    NODE_URL="https://nodejs.org/dist/v22.14.0/node-v22.14.0.pkg"
    echo "🔗 ダウンロードURL: $NODE_URL"
    curl -L -o node.pkg "$NODE_URL"
    echo "▶️ Node.js インストーラーを起動します（手動でインストール）..."
    open node.pkg
    echo "💤 Node.js のインストールが終わったら Enter を押してください"
    read -p "続行するには Enter を押してください... "
fi

############################################
# 3. Pandoc インストール
############################################
if command -v pandoc >/dev/null 2>&1; then
    echo "✅ Pandoc はすでにインストールされています"
else
    ARCH=$(uname -m)
    if [ "$ARCH" = "arm64" ]; then
        PANDOC_ARCH="arm64"
    elif [ "$ARCH" = "x86_64" ]; then
        PANDOC_ARCH="x86_64"
    else
        echo "❌ 未対応のCPU: $ARCH"
        exit 1
    fi

    PANDOC_VERSION="3.6.4"
    PANDOC_FILENAME="pandoc-${PANDOC_VERSION}-${PANDOC_ARCH}-macOS.zip"
    PANDOC_URL="https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/${PANDOC_FILENAME}"

    echo "📦 Pandoc をダウンロード中..."
    curl -L -o "$PANDOC_FILENAME" "$PANDOC_URL"
    unzip -q "$PANDOC_FILENAME"
    sudo cp -r pandoc-${PANDOC_VERSION}/* /usr/local/
    echo "✅ Pandoc をインストールしました"
fi

############################################
# 4. code コマンドの PATH に追加（スキップ付き）
############################################
CODE_BIN_PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
SHELL_CONFIG=""

if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_CONFIG="$HOME/.bash_profile"
else
    SHELL_CONFIG="$HOME/.zshrc"  # なければ新規作成
fi

if ! echo "$PATH" | grep -q "$CODE_BIN_PATH"; then
    if ! grep -q "$CODE_BIN_PATH" "$SHELL_CONFIG"; then
        echo "🛠️ code コマンドを $SHELL_CONFIG に追加します"
        echo "" >> "$SHELL_CONFIG"
        echo "# VSCode CLI" >> "$SHELL_CONFIG"
        echo "export PATH=\"\$PATH:$CODE_BIN_PATH\"" >> "$SHELL_CONFIG"
    fi
    export PATH="$PATH:$CODE_BIN_PATH"
else
    echo "✅ code コマンドはすでにPATHに含まれています"
fi

############################################
# 5. npm install
############################################
cd "$REPO_DIR"
echo "📦 npm install を実行します..."
npm install
echo "✅ npm install 完了"

############################################
# 6. VSCode 拡張のインストール（スキップ付き）
############################################
echo "🔌 拡張機能をインストール中..."

EXTS=("3w36zj6.textlint" "appulate.filewatcher")

for EXT in "${EXTS[@]}"; do
    if code --list-extensions | grep -q "$EXT"; then
        echo "✅ $EXT はすでにインストールされています"
    else
        code --install-extension "$EXT"
        echo "✅ $EXT をインストールしました"
    fi
done

############################################
# 7. VSCode 起動
############################################
echo "🚀 VSCode を起動します..."
open -a "Visual Studio Code" "$REPO_DIR"

echo ""
echo "🎉 セットアップ完了！すべてのツールが整いました 🚀"
