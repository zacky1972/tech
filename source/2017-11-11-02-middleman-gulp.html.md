---
title: Middleman v4 で gulp を使えるようにする
---
# Middleman v4 で gulp を使えるようにする

gulp は　javascript のビルドシステムです。

## 参考記事

* [middleman+gulpで静的サイトのテンプレート的な物を作ってみる](http://t4traw.github.io/tech/20160331tech.html)

## 前提

Middleman に npm をインストールしておきます。

1. [GitHub Pages で Middleman v4 を使う](https://zacky1972.github.io/tech/2017/11/04/middleman.html)
2. [Middleman v4 で npm を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/01-middleman-npm.html)

## 手順

1. npm で gulp をインストールする
2. config.rb を編集する
3. gulpfile.js を作成する
4. middleman build でエラーがないことを確認する

## 1. npm で gulp をインストールする

```
$ cd (Middleman のディレクトリ)
$ npm install gulp --save-dev
```

## 2. config.rb を編集する

config.rb に次の記述を足します。

```ruby
ignore 'REAMDME.md'

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :layouts_dir, 'layouts'

activate :external_pipeline,
  name: :gulp,
  command: build? ? './node_modules/gulp/bin/gulp.js' : './node_modules/gulp/bin/gulp.js watch',
  source: "source"

configure :build do
  ignore 'stylesheets/*'
  ignore 'javascripts/*'
end
```

ポイントは次の通りです。

* :css_dir などで middleman の stylesheets その他を指すようにする。そうしないと gulp でビルドする時にエラーが出る
* build の時に stylesheets と javascripts のファイルを無視する。そうしないと，site.css などが正しく参照されない

## 3. gulpfile.js を作成する

gulpfile.js が存在しなかったり，空だったりするとエラーになるので，最低限の記述をしておきます。


```javascript
var gulp = require('gulp');

gulp.task('default', function(){
  //
});

gulp.task('watch', function(){
  //
});
```

## 4. middleman build でエラーがないことを確認する

次のコマンドを実行します。

```
$ cd (Middleman のディレクトリ)
$ middleman build
```

エラーがなくビルドが完了すれば成功です。

私の場合は，index.html.slim に YAML Front Matter で title を指定していたのですが，middleman build でエラーになったので，一旦外しました。この問題の修正は後ほど行おうと思います。

