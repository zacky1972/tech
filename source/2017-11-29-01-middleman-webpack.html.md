---
title: Middleman v4 で Webpack を使えるようにする
---
# Middleman v4 で Webpack を使えるようにする

今までブラウザ側の Javascript を Browserify で管理していたのですが，最近は Webpack の方がいいらしいという情報をキャッチしたので，新しく立ち上げる Middleman のウェブサイトのために，Webpack ベースで立ち上げてみることにしました。

## 参考記事

* [MiddlemanのビルドにWebpackを組み込む方法](https://blog.leko.jp/post/how-to-use-webpack-with-middleman/)

## 前提

Middleman に npm と gulp をインストールしておきます。

1. [GitHub Pages で Middleman v4 を使う](https://zacky1972.github.io/tech/2017/11/04/middleman.html)
2. [Middleman v4 で npm を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/01-middleman-npm.html)

## 手順

1. npm で Webpack をインストールする
2. package.json に Webpack の設定を追加する
3. config.rb に Webpack の設定を追加する
4. webpack.config.js を作成する
5. layout.slim に bundle.js を指定する

## 1. npm で Webpack をインストールする

```
$ cd (Middleman のディレクトリ)
$ npm install webpack --save-dev
$ npm install -g webpack
```

## 2. package.json に Webpack の設定を追加する

package.json の script 設定の行に下記を追加します。

```json
  "scripts": {
  	"develop": "webpack --config ./webpack.config.js --watch -d --progress --colors",
    "build": "webpack --config ./webpack.config.js --bail -p",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
```

## 3. config.rb に Webpack の設定を追加する

config.rb に次の記述を足します。

```ruby
activate :external_pipeline, {
  name: :webpack,
  command: build? ?
    "NODE_ENV=production npm run build" :
    "NODE_ENV=develop npm run develop",
  source: "./build",
  latency: 1
}
```

## 4. webpack.config.js を作成する

Middleman のディレクトリに webpack.config.js を下記のように作成します。

```javascript
const webpack = require('webpack');

module.exports = {
  entry: [
    './source/javascripts/site.js'
  ],
  output: {
    filename: 'bundle.js',
    path: __dirname + '/build/javascripts'
  }
};
```

Webpack は entry に指定している javascript ファイルを取りまとめて bundle にしてくれます。 Middleman のデフォルトである all.js を指定してももちろん構わないと思います。

取りまとめた javascript は output に指定している ./build/javascripts/bundle.js に出力されます。これが config.rb の source で指定しているパスと齟齬がないようにすれば OK です。

## 5. layout.slim に bundle.js を指定する

source/layouts/layout.slim の javascript の読み込みを下記のように変更して bundle.js を読み込むようにします。(ついでに非同期読み込みを指定します)

```slim
    == javascript_include_tag  "bundle", async: 'async'
```

## 確認方法

まず，次のコマンドを入力します。

```
$ webpack
```

次のようにエラーなく実行され，build/javascripts/bundle.js が生成させていれば OK です。

```
$ webpack
Hash: 25bed11ced0c0e3ed8b3
Version: webpack 3.8.1
Time: 93ms
    Asset     Size  Chunks             Chunk Names
bundle.js  2.64 kB       0  [emitted]  main
   [0] multi ./source/javascripts/site.js 28 bytes {0} [built]
   [1] ./source/javascripts/site.js 52 bytes {0} [built]
$ ls build/javascripts/bundle.js 
build/javascripts/bundle.js
```

これが確認できたら次のコマンドを入力します。

```
$ middleman build
```

次のようにエラーなく実行されることを確認してください。

```
$ middleman build
Please report a bug if this causes problems.
== Executing: `NODE_ENV=production npm run build`
== External: > swest@1.0.0 build /Users/zacky/Dropbox/SWEST-github
== External: > webpack --config ./webpack.config.js --bail -p
== External: Hash: 496ba021153ca9314d82
== External: Version: webpack 3.8.1
== External: Time: 117ms
== External:     Asset       Size  Chunks             Chunk Names
== External: bundle.js  511 bytes       0  [emitted]  main
== External:    [0] multi ./source/javascripts/site.js 28 bytes {0} [built]
== External:    [1] ./source/javascripts/site.js 33 bytes {0} [built]
      create  build/stylesheets/site-e6ded883.css
      create  build/javascripts/bundle-a94bac44.js
      create  build/images/middleman-logo-257e02f7.svg
      create  build/javascripts/site-182b97d3.js
      create  build/javascripts/all-cc830994.js
      create  build/images/.keep
      create  build/index.html
      remove  build/javascripts/bundle.js
Project built successfully.
```

なお，site, bundle, middleman-logo, all の後の番号はハッシュ値なので，内容が変わるたびに値が変わります。

build/index.html を開いた時に，次のように bundle-\*.js が読み込まれていれば OK です。

```html
<script src="***/javascripts/bundle-a94bac44.js" async="async"></script>
```

