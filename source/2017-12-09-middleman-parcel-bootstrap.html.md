---
title: Middleman v4 + parcel で Bootstrap を使う
---
# Middleman v4 + parcel で Bootstrap を使う

parcel 環境で Bootstrap を使えるようにしてみました。ちょっと残念なことに，完全に parcel だけではうまくいかず，scss の変換で gulp を併用しています。

## 前提

* [Middleman v4 で parcel を使ってみる](https://zacky1972.github.io/tech/2017/12/08/middleman-parcel.html)

## 手順

1. yarn で gulp を追加する
2. yarn で gulp-coffee と gulp-sass を追加する
3. config.rb の external_pipeline の設定に parcel と gulp を追加する
4. gulp.coffee に scss を変換する設定を追加する
5. site.css.scss を site.scss にリネームする
6. yarn で jQuery, bootstrap, popper.js を追加する
7. site.scss の bootstrap の記述を追加する
8. site.js (もしくは all.js) に bootstrap の記述を追加する

## 1. yarn で gulp を追加する

```
$ cd (Middlemanのディレクトリ)
$ yarn global add gulp
$ yarn add gulp
```

## 2. yarn で gulp-coffee と gulp-sass を追加する

```
$ cd (Middlemanのディレクトリ)
$ yarn add gulp-coffee gulp-sass
```

## 3. config.rb の external_pipeline の設定に parcel と gulp を追加する

config.rb の external_pipeline の設定を次のようにします。

```ruby
activate :relative_assets

activate :external_pipeline, {
	name: :parcel,
	command: "parcel build source/javascripts/site.js --out-dir build/javascripts/",
	source: "./build",
	latency: 1
}

activate :external_pipeline, {
	name: :gulp,
	command: "gulp build:sass",
	source: "./build",
	latency: 1
}
```

好みで source/javascripts/site.js を source/javascripts/all.js にしてもいいです。

## 4. gulp.coffee に scss を変換する設定を追加する

Middleman のディレクトリに下記のような gulp.coffee を追加します。

```coffee
gulp = require 'gulp'
sass = require 'gulp-sass'

gulp.task 'build:sass', () ->
  gulp.src 'source/stylesheets/**/*.scss'
    .pipe sass()
    .pipe gulp.dest('build/stylesheets/')
```

## 5. site.css.scss を site.scss にリネームする

```
$ cd (Middlemanのディレクトリ)
$ mv source/stylesheets/site.css.scss source/stylesheets/site.scss 
```

## 6. yarn で jQuery, bootstrap, popper.js を追加する

```
$ cd (Middlemanのディレクトリ)
$ yarn add jquery bootstrap@4.0.0-beta.2 popper.js
```

## 7. site.scss の bootstrap の記述を追加する

source/stylesheets/site.scss の冒頭を次のようにします。

```scss
@charset "utf-8";
@import "normalize";
@import "../../node_modules/bootstrap/scss/bootstrap";
```

## 8. site.js (もしくは all.js) に bootstrap の記述を追加する

source/javascripts/site.js (もしくは all.js) に次のように記述します。

```javascript
require('jquery');
require('popper.js');
require('bootstrap');
```

## 確認方法

まず，Javascript Console でエラーが出ていないことを確認しましょう。

次に source/index.html.slim に下記を追記してボタンを配置してみましょう。

```slim
.container
    button type="button" class="btn btn-danger" Danger
```

サーバーを立ち上げます。

```
$ cd (Middleman のディレクトリ)
$ middleman server
```

[http://localhost:4567](http://localhost:4567) を表示した時に赤いボタンが表示されていれば成功です。

次に source/stylesheets/site.css.scss に下記を追記してみましょう。


```
body {
	background: orange;
}

@include media-breakpoint-up(md) {
  body {
    background: red;
  }
}
```

サーバーを立ち上げます。

```
$ cd (Middleman のディレクトリ)
$ middleman server
```

PC で　[http://localhost:4567](http://localhost:4567) を表示した時，画面を広くした時に背景が赤くなり，狭くした時に背景がオレンジになれば成功です。


