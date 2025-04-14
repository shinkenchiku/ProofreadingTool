# dictionary.ymlの作り方

## 公式ドキュメント

[.ymlの書き方](https://github.com/prh/prh/blob/master/misc/prh.yml)

## ymlについて

``` yml
version: 1
rules:
  - expected: アイデア
    pattern: アイディア
    prh: ここにエラー時のメッセージを入力しておき校正の意図を示します
    specs:
      - from: アイディアを出す
        to:   アイデアを出す
      - from: アイディアがある
        to:   アイデアがある
```

YAMLではインデントが非常に重要です。
上記のYAMLでは、いちばん深い要素は第三階層です。

構造はフォルダ階層のように捉えると理解しやすく、たとえば：

- rules の下に expected, pattern, specs などがある
- version の下には 1 という値が指定されている

となります。

また、`-`が付いている行は「配列の要素」を意味します。
通常、YAMLでは同じキーを複数使えませんが、`-` を使うことで同じ階層内に同じキーを複数定義できます。

このように`-`から始まるブロックは、それぞれひとつのルール（構造体）として扱われます。

### 階層

#### 第一階層

- version
- rules

#### 第二階層

- rules 配下の：expected, pattern, specs

#### 第三階層

- specs 配下の：from, to

## dictionaryの書き方

ひとつのルールとして重要なのは、rules 配下の expected, pattern です。
他にも使えるキーはありますが、最低限このふたつで動作します。

``` yml
rules:
  - expected: アイデア
    pattern:  アイディア
```

ここでは `pattern` にマッチした語を、`expected` に変換します。
`pattern` は配列として複数指定することも可能です。

``` yml
rules:
  - expected: ハードウェア
    patterns:
      - ハードウエアー
      - ハードウェアー
      - ハードウエア
```

これらを組み合わせると、次のような辞書になります。

``` yml
rules:
  - expected: アイデア
    pattern: アイディア
  - expected: ハードウェア
    patterns:
      - ハードウエアー
      - ハードウェアー
      - ハードウエア
```

このように辞書を充実させていくことで、多くの文章の表記統一や校正が可能になります。

## expectedだけの記述も可能

説明が後になりましたが、次のように expected だけを指定することもできます：

``` yml
rules:
  - expected: Cookie
```

これは、`COOKIE` や `Cｏｏkｉｅ`、あるいは `cOｏKie` のような表記揺れをすべて Cookie に統一してくれます。

iOS や iPhone など、正しい表記が決まっているものは、こうして登録しておくと便利です。

## specsとは何か？

specs はテスト用の設定です。
from の表現が、to に正しく変換されるかどうかをチェックできます。
テストとして自動的にチェックできるので、ルールの確認用として書いておきましょう。

## より高度な書き方

次のように正規表現（Regular Expression）を使うことでより複雑な表現が可能です
以下は 半角の括弧`()`で囲われた文字を全角の括弧`（）`に校正しています

``` yml
rules:
  - expected: （$1）
    pattern:  /\(([^)]+)\)/
    specs:
      - from: (注釈)
        to:   （注釈）
```

正規表現の説明は[wikipedia](https://ja.wikipedia.org/wiki/%E6%AD%A3%E8%A6%8F%E8%A1%A8%E7%8F%BE)や[サルでもわかる正規表現入門](https://userweb.mnet.ne.jp/nakama/)を確認してください

## 条件付きの正規表現

次の例では、「ソフトウエア」を「ソフトウェア」に変換します。
ただし、「日経ソフトウエア」のような雑誌名はそのままにしたい場合です。

``` yml
rules:
  - expected: ソフトウェア
    pattern:  /(日経)?ソフトウエア/
    regexpMustEmpty: $1
    specs:
      - from: 広義のソフトウエア
        to:   広義のソフトウェア
      - from: 日経ソフトウエア
        to:   日経ソフトウエア
      - from: ソフトウエア
        to:   ソフトウェア
```

`pattern` の `()` 内でキャプチャした `$1` が空（=マッチしていない:regexpMustEmpty）である場合のみ変換されます。
さらに、「日経」以外に「産経」なども除外対象にしたい場合は、次のように `|` で連結します。

``` yml
rules:
  - expected: ソフトウェア
    pattern:  /(日経|産経)?ソフトウエア/
    regexpMustEmpty: $1
    specs:
      - from: 広義のソフトウエア
        to:   広義のソフトウェア
      - from: 日経ソフトウエア
        to:   日経ソフトウエア
      - from: 産経ソフトウエア
        to:   産経ソフトウエア
      - from: ソフトウエア
        to:   ソフトウェア
```

## 短い単語の場合

`js`などの短い単語単語の中のものを拾ってしまう可能性があります
そのような場合には `options: wordBoundary: true`をつけることが推奨されています

``` yml
rules:
  - expected: js
    options:
      wordBoundary: true
    specs:
      - from: foo JS bar
        to:   foo js bar
      - from: foo altJS bar
        to:   foo altJS bar
      - from: 今日もJS祭り
        to:   今日もjs祭り
```
