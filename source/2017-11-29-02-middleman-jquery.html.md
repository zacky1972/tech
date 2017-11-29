---
title: Middleman v4 + webpack の上に jQuery を使えるようにする
---
# Middleman v4 + webpack の上に jQuery を使えるようにする


## 参考記事

* [webpackでjQueryを読み込む２つの方法](http://elsur.xyz/webpack-jquery-ways-to-work)
* [webpack 公式ドキュメント〜Configuration](https://webpack.js.org/configuration/)


## 前提

Middleman に npm, Webpack をインストールしておきます。

1. [GitHub Pages で Middleman v4 を使う](https://zacky1972.github.io/tech/2017/11/04/middleman.html)
2. [Middleman v4 で npm を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/01-middleman-npm.html)
3. [Middleman v4 で Webpack を使えるようにする](https://zacky1972.github.io/tech/2017/11/29/01-middleman-webpack.html)

## 手順

1. npm を使って jQuery をインストールする
2. webpack.config.js に jQuery の設定をする
3. site.js に jQuery を読み込む設定をする

## 1. npm を使って jQuery をインストールする

```
$ cd (Middleman のディレクトリ)
$ npm install jquery --save
```

## 2. webpack.config.js に jQuery の設定をする

webpack.config.js を次のようにします。

```javascript
const webpack = require('webpack');

module.exports = {
	entry: [
		'./source/javascripts/site.js'
	],
	output: {
		filename: 'bundle.js',
		path: __dirname + '/build/javascripts'
	},
  plugins: [
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery'
    })
  ]
};
```

## 3. site.js に jQuery を読み込む設定をする

source/javascripts/site.js に次の記述を追加します。

```javascript
require('jquery');
```

## 確認方法

次のコマンドを実行してエラーがないことを確認します。

```
$ webpack
```

build/javascripts/bundle.js を開いて jQuery が読み込まれていることを確認します。

次に site.js の require('jquery') より下に次の記述を足します。

```javascript
$('body').css('background-color', 'red');
```

ビルドしてサーバーを立ち上げます。

```
$ cd (Middleman のディレクトリ)
$ middleman build
$ middleman serve
```

[http://localhost:4567](http://localhost:4567) を表示した時に背景色が赤になっていれば成功です。

site.js に追加した次の記述を削除しておきましょう。

```javascript
$('body').css('background-color', 'red');
```

## 感想

browserify + gulp を使った場合に比べて，圧倒的に楽になっています。
