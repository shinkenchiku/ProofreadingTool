# 校正ツール用リポジトリ

## 概要

このリポジトリは新建築社グループにおいて校正の自動化および均一化を目指すためのリポジトリです。
次のステップに則りツールをインストールしていくことによってVScode（テキストエディター）の作業において、校正の自動化および問題のある点のハイライトを行います

## Installation

### Macの場合

`mac.command`を実行してください

### Windowsの場合

準備中

## インストールされたもの

### APP

APPはアイコンがありダブルクリックすると独自のUIが出てくるようないわゆるアプリケーションです

- [Visual Studio Code(VScode)](https://code.visualstudio.com/)

### CLIツール

CLIツール（コマンドラインインターフェースツール）はAPPとは違いコマンドライン（MacならTerminal、Windowsならコマンドプロンプト）で使われるものです。今回の場合あまり意識する必要はありません。バックグラウンドで動いているものと認識してください。

- [node.js](https://nodejs.org/ja)
  - javascriptの実行環境。詳しくは上記のURLで
- [pandoc](https://pandoc.org/installing.html)
  - ドキュメントの変換ツール。docxからmarkdownなどファイルフォーマットの変換を行う

### VSCode Extention

VScodeのextentionです。

- [textlint](https://marketplace.visualstudio.com/items/?itemName=3w36zj6.textlint)
  - 校正を行う拡張機能。辞書や構文を設定したファイルを見て処理してくれるtextlintを使えるようにするもの

- [File Watcher](https://marketplace.visualstudio.com/items/?itemName=appulate.filewatcher)
  - ファイルの変更を監視する拡張機能。今回はdocsのファイルをmdにしたり、校正後の変更を伝えるためのファイルを自動で作成するために利用。

## How To

### フォルダ校正

``` plane_text
.
├── .vscode                 # VScodeの設定ファイルや自動実行のshellscriptが入っている
├── .textlintrc             # textlint用の設定ファイル。
├── original                # originalの原稿を入れるフォルダ。
├── proofread/              # 校正を行うためのフォルダ。
│   ├── *.md
│   └── original_md/        # 差分検出用のファイル
│       └── *_origina.md
├── exports/                # proofreadで保存をするとこちらに差分付きでdocxファイルが作成される。
│   ├── *.docx
│   └── SimpleUI/           # この.htmlはwordなどを使っていない人に見せるときにわかりやすくなる
│       └── *.html
├── textlint_rules/         # 校正ルールを入れるフォルダ
│   ├── dictionary/         # 辞書型のルール
│   │   ├── jutaku/
│   │   │   └── *.yml
│   │   └── *.yml
│   └── morpheme_match/     # 品詞を解析して文章の禁則などを指定できる
│       └── *.js
├── textlint_manuals/       # 校正ルールの作成方法についてのマニュアル
│   └── SomthingManuals.md  
├── README.md
├── tmp/
│   └── diff.log            # ログ。ある程度大きくなってしまったら削除してしまって良い
├── node_modules/
├── package.json
├── package-lock.json
├── mac.command             # Mac用のinstallコマンド
└── windows.bat             # Windows用のinstallバッチ[WIP]
```

### 基本的な使い方

1. originalフォルダに元ファイルを追加
2. proofreadフォルダに自動で`元ファイル名.md`が作られる
3. そのファイルを変更後保存
4. exportsフォルダに`元ファイル名.docx`のファイルが作られるのでそれを作者に返す。もしくはexports/SimpleUIフォルダの中の.htmlを渡す。

proofreadフォルダのファイルを開くと校正が必要な場所に赤い線が引かれます。マウスオーバーすることによりなぜ校正が必要なのかが分かるようになっています。それに合わせて手動で変更してください。

もしくは、全自動で修正することも可能です。ファイルを開いた後にVScode上部の検索フィールドに`> textlint`と入力することによってtextlintにかかわるコマンドの一覧が出てきます。そのうちの`> textlint: Fix all auto-fixable Problems`を実行することによって自動で置き換わります。ただし文法の間違いなどの単純置き換えは実行されません。

### 校正ルールの選択

.textlintrcでは校正ルールの選択が行われます。もし部署ごとに独自の設定がある場合は利用しください

``` json
{
  "rules": {
    "prh": {
      "rulePaths": [
        "./textlint_rules/dictionary/jutaku/hiraki.yml",
        "./textlint_rules/dictionary/jutaku/okuri.yml",
        "./textlint_rules/dictionary/jutaku/tozi.yml",
        "./textlint_rules/dictionary/texkbooster.yml"
      ]
    },
    "@textlint-ja/morpheme-match": {
      "dictionaryPathList": ["./textlint_rules/morpheme_match/list.js"]
    },
    "textlint-rule-preset-japanese": true,
    "ja-no-orthographic-variants": true
  }
}
```

`prh > rulePaths`が辞書。`@textlint-ja/morpheme-match > dictionaryPathList`が文法にかかわるものです。

また、`textlint-rule-preset-japanese`は一般的な日本語文章のチェック（[リファレンス](https://github.com/textlint-ja/textlint-rule-preset-japanese)）。`ja-no-orthographic-variants`は表記揺れのチョック用のライブラリです（[リファレンス](https://github.com/textlint-ja/textlint-rule-ja-no-orthographic-variants)）。どちらも`true`から`false`に変更することで外すことができます

### 校正ルールの作り方

- 辞書登録は[こちら](./textlint_manuals/dictionaryの作り方.md)
- 形態素解析による文章ルールの作成は[こちら](./textlint_manuals/MorphemeMatchの作り方.md)
