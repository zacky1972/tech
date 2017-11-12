---
title: Middleman v4 + gulp + Browserify で jQuery を使えるようにする
---
# Middleman v4 + gulp + Browserify で jQuery を使えるようにする

Middleman v4 は外部パイプラインになったので，それに合わせて Middleman への jQuery のインストールの方法も多様なバリエーションが提供されるようになりました。今回はその1つとして，gulp，Browserify を使った方法を説明します。

この中で browserify-shim を使います。browserify-shim は jQuery などの CommonJS に対応していないモジュールを Browserify で使えるようにするツールです。

## 参考記事

* [Browserify と browserify-shim でグローバルオブジェクトを扱う](https://whiskers.nukos.kitchen/2016/11/08/browserify-shim.html)

## 前提

Middleman に npm, gulp, Browserify をインストールしておきます。

1. [GitHub Pages で Middleman v4 を使う](https://zacky1972.github.io/tech/2017/11/04/middleman.html)
2. [Middleman v4 で npm を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/01-middleman-npm.html)
3. [Middleman v4 で gulp を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/02-middleman-gulp.html)
4. [Middleman v4 で Browserify を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/03-middleman-browserify.html)
5. [Middleman v4 + gulp + Browserify で Sass/Scss を使えるようにする](zacky1972.github.io/tech/2017/11/11/04-middleman-sass.html)

## 手順

1. npm で jQuery をインストールする
2. all.js に jQuery を追加する
3. layout.slim を書き換えて bundle.js の読み込みを body 以降にする
4. npm で browserify-shim をインストールする
5. package.json を書き換えて browserify-shim を有効にする
6. npm でインストールした jQuery を browserify-shim が認識するようにする
7. browserify-shim で jQuery をモジュール化するようにする

## 1. npm で jQuery をインストールする

次のコマンドを実行します。

```
$ cd (Middleman のディレクトリ)
$ npm install --save jquery
```

## 2. all.js に jQuery を追加する

source/javascripts/all.js に次の記述を追記します。

```javascript
require('jquery');
```

## 3. layout.slim を書き換えて bundle.js の読み込みを body 以降にする

source/layouts/layout.slim を書き換えて，下記のように bundle.js の読み込みを body 以降にします。

```slim
    == stylesheet_link_tag :site

  body class="#{page_classes}"
    == javascript_include_tag  "bundle"

    == yield
```

## 4. npm で browserify-shim をインストールする

次のコマンドを実行します。

```
$ cd (Middleman のディレクトリ)
$ npm install --save-dev browserify-shim
```

## 5. package.json を書き換えて browserify-shim を有効にする

package.json に次の記述を足します。これにより Browserify が browserify-shim を認識します。

```json
  "browserify": {
    "transform": [
      "browserify-shim"
    ]
  },
```

## 6. npm でインストールした jQuery を browserify-shim が認識するようにする

package.json に次の記述を足します。これにより browserify-shim が jquery と指定するだけで npm でインストールした jQuery を読みにいくようになります。

```json
  "browser": {
    "jquery": "./node_modules/jquery/dist/jquery.js"
  },
```

## 7. browserify-shim で jQuery をモジュール化するようにする

package.json に次の記述を足します。これにより browserify-shim が働いて jQuery がうまいことモジュール化されるようになります。

```json
  "browserify-shim": {
    "jquery": "$"
  }
```


## 確認方法

source/javascripts/all.js の require('jquery') より後に次の記述を追加します。

```javascript
$('body').css('background-color', 'orange');
```

ビルドしてサーバーを立ち上げます。

```
$ cd (Middleman のディレクトリ)
$ middleman build
$ middleman server
```

[http://localhost:4567](http://localhost:4567) を表示した時に背景色がオレンジ色になっていれば成功です。

source/javascripts/all.js に追加した次の記述を削除しておきましょう。

```javascript
$('body').css('background-color', 'orange');
```
