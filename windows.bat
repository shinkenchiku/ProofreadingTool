@echo off
setlocal

:: 作業ディレクトリ
set "WORKDIR=%USERPROFILE%\Downloads\setup_tools"
mkdir "%WORKDIR%"
cd /d "%WORKDIR%"

:: Visual Studio Code ダウンロード＆実行
echo 📦 Downloading VSCode...
powershell -Command "Invoke-WebRequest -Uri https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user -OutFile vscode_setup.exe"
start "" vscode_setup.exe
echo 💤 VSCode インストールが終わったら Enter を押してください
pause

:: Node.js ダウンロード＆実行
echo 📦 Downloading Node.js...
powershell -Command "$url = (Invoke-WebRequest https://nodejs.org/en).Links | Where-Object { $_.href -match 'node-v.*-x64\.msi' } | Select-Object -First 1 -ExpandProperty href; $full = 'https://nodejs.org' + $url; Invoke-WebRequest $full -OutFile node.msi"
start "" node.msi
echo 💤 Node.js インストールが終わったら Enter を押してください
pause

:: Pandoc ダウンロード＆解凍（x64固定、ほとんどのWindowsはこれ）
set "PANDOC_VER=3.6.4"
set "PANDOC_ZIP=pandoc-%PANDOC_VER%-windows-x86_64.zip"
set "PANDOC_URL=https://github.com/jgm/pandoc/releases/download/%PANDOC_VER%/%PANDOC_ZIP%"

echo 📦 Downloading Pandoc...
powershell -Command "Invoke-WebRequest -Uri %PANDOC_URL% -OutFile %PANDOC_ZIP%"
powershell -Command "Expand-Archive -Path %PANDOC_ZIP% -DestinationPath pandoc"
xcopy /E /Y /I ".\pandoc\pandoc-%PANDOC_VER%" "C:\Program Files\Pandoc"
echo ✅ Pandoc installed

:: 環境変数に pandoc を追加
setx PATH "%PATH%;C:\Program Files\Pandoc"

:: リポジトリに戻る（バッチファイルのある場所）
cd /d "%~dp0"

:: npm install
IF EXIST "package.json" (
    echo 📦 Running npm install...
    powershell -Command "npm install"
) ELSE (
    echo ⚠️ package.json not found, skipping npm install
)

:: VSCode 拡張インストール
echo 🔌 Installing VSCode extensions...
set "CODE_CMD=%LOCALAPPDATA%\Programs\Microsoft VS Code\bin\code"
"%CODE_CMD%" --install-extension 3w36zj6.textlint
"%CODE_CMD%" --install-extension appulate.filewatcher

:: VSCode起動
echo 🚀 Launching VSCode...
start "" "%CODE_CMD%" .

echo.
echo 🎉 Setup complete!
pause
