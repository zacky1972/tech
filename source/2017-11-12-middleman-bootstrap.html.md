---
title: Middleman v4 + gulp + Browserify で Bootstrap v4 を使えるようにする
---
# Middleman v4 + gulp + Browserify で Bootstrap v4 を使えるようにする

いよいよ Bootstrap v4 をインストールします。ここまで長かった。

## 前提

Middleman に npm, gulp, Browserify, jQuery をインストールしておきます。

1. [GitHub Pages で Middleman v4 を使う](https://zacky1972.github.io/tech/2017/11/04/middleman.html)
2. [Middleman v4 で npm を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/01-middleman-npm.html)
3. [Middleman v4 で gulp を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/02-middleman-gulp.html)
4. [Middleman v4 で Browserify を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/03-middleman-browserify.html)
5. [Middleman v4 + gulp + Browserify で Sass/Scss を使えるようにする](zacky1972.github.io/tech/2017/11/11/04-middleman-sass.html)
6. [Middleman v4 + gulp + Browserify で jQuery を使えるようにする](zacky1972.github.io/tech/2017/11/11/05-middleman-jquery.html)

## 手順

1. npm で Bootstrap v4 と Popper.js をインストールする
2. all.js に Bootstrap を追加する
3. gulpfile.js に Bootstrap の CSS ファイルをコピーするタスクを追加する
4. layout.slim にレスポンシブメタタグを追加する
5. site.scss に Bootstrap を追加する
6. package.json を書き換えて npm でインストールした Bootstrap v4 と Popper.js を認識するようにする
7. package.json を書き換えて browserify-shim で Bootstrap v4 と Popper.js をモジュール化するようにする

## 1. npm で Bootstrap v4 と Popper.js をインストールする

Bootstrap の2017年11月12日現在のバージョンは v4.0.0-beta.2 です。

次のコマンドを実行します。

```
$ cd (Middleman のディレクトリ)
$ npm install --save bootstrap@4.0.0-beta.2 popper.js
```

Popper.js はツールチップです。Bootstrap v4 が Popper.js を要求するのでインストールしました。

## 2. all.js に Bootstrap を追加する

source/javascripts/all.js の require('jquery') 以下を次のようにします。

```javascript
var $ = require('jquery');
require('popper.js');
require('bootstrap');
```

## 3. gulpfile.js に Bootstrap の CSS ファイルをコピーするタスクを追加する

guilpfile.js に Bootstrap の CSS ファイルをコピーするタスクを追加します。

```javascript
gulp.task('build', ['sass', 'bundle', 'bootstrap']);

gulp.task('bootstrap', copyBootstrapCSS);

function copyBootstrapCSS() {
  gulp.src('node_modules/bootstrap/dist/css/bootstrap-grid.min.css')
    .pipe(gulp.dest('./build/stylesheets'));
  gulp.src('node_modules/bootstrap/dist/css/bootstrap-grid.min.css.map')
    .pipe(gulp.dest('./build/stylesheets'));
  gulp.src('node_modules/bootstrap/dist/css/bootstrap-reboot.min.css')
    .pipe(gulp.dest('./build/stylesheets'));
  gulp.src('node_modules/bootstrap/dist/css/bootstrap-reboot.min.css.map')
    .pipe(gulp.dest('./build/stylesheets'));
  gulp.src('node_modules/bootstrap/dist/css/bootstrap.min.css')
    .pipe(gulp.dest('./build/stylesheets'));
  gulp.src('node_modules/bootstrap/dist/css/bootstrap.min.css.map')
    .pipe(gulp.dest('./build/stylesheets'));
}
```

guilpfile.js の全体は次のようになります。

```javascript
var gulp = require('gulp');
var source = require('vinyl-source-stream');
var browserify = require('browserify');
var sass = require('gulp-sass');
var neat = require('node-neat');

var jsConf = {
  srcPath: 'source/javascripts/all.js',
  destFileName: 'javascripts/bundle.js',
  destPath: '.tmp/dist/'
}

var cssConf = {
  srcPath: 'source/stylesheets/**/*.scss',
  destFileName: 'site',
  destPath: '.tmp/dist/stylesheets'
}

var b = browserify({
  entries: jsConf.srcPath,
  cache: {},
  packageCache: {}
});

gulp.task('default', ['build']);
gulp.task('build', ['sass', 'bundle', 'bootstrap']);
gulp.task('watch', function(){
  //
});
gulp.task('bundle', jsBundle);
gulp.task('sass', sassPreCompile);
gulp.task('bootstrap', copyBootstrapCSS);

function jsBundle() {
  return b.bundle()
    .pipe(source(jsConf.destFileName))
    .pipe(gulp.dest(jsConf.destPath));
}

function sassPreCompile() {
  gulp.src(cssConf.srcPath)
    .pipe(sass({
      includePaths: cssConf.destFileName
    }))
    .pipe(gulp.dest(cssConf.destPath));
}

function copyBootstrapCSS() {
  gulp.src('node_modules/bootstrap/dist/css/bootstrap-grid.min.css')
    .pipe(gulp.dest('./build/stylesheets'));
  gulp.src('node_modules/bootstrap/dist/css/bootstrap-grid.min.css.map')
    .pipe(gulp.dest('./build/stylesheets'));
  gulp.src('node_modules/bootstrap/dist/css/bootstrap-reboot.min.css')
    .pipe(gulp.dest('./build/stylesheets'));
  gulp.src('node_modules/bootstrap/dist/css/bootstrap-reboot.min.css.map')
    .pipe(gulp.dest('./build/stylesheets'));
  gulp.src('node_modules/bootstrap/dist/css/bootstrap.min.css')
    .pipe(gulp.dest('./build/stylesheets'));
  gulp.src('node_modules/bootstrap/dist/css/bootstrap.min.css.map')
    .pipe(gulp.dest('./build/stylesheets'));
}
```

## 4. layout.slim にレスポンシブメタタグを追加する

source/layouts/layout.slim の head 部分を下記のようにします。

```slim
  head
    meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible"
    meta charset="utf-8"
    meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"
```

## 5. site.scss に Bootstrap を追加する

source/stylesheets/site.scss に下記の記述を足します。

```scss
@import "./node_modules/bootstrap/scss/bootstrap.scss";
```

## 6. package.json を書き換えて npm でインストールした Bootstrap v4 と Popper.js を認識するようにする

package.json の browser の設定を次のように書き換えます。

```json
  "browser": {
    "bootstrap": "./node_modules/bootstrap/dist/js/bootstrap.js",
    "popper.js": "./node_modules/popper.js/dist/umd/popper.js",
    "jquery": "./node_modules/jquery/dist/jquery.js"
  },
```

## 7. package.json を書き換えて browserify-shim で Bootstrap v4 と Popper.js をモジュール化するようにする

package.json の browserify-shim の設定を次のように書き換えます。

```json
  "browserify-shim": {
    "jquery": "$",
    "popper.js": "$",
    "bootstrap": {
      "exports": "$",
      "depends": [
        "jquery:jQuery",
        "popper.js:Popper.js"
      ]
    }
  },
```

packege.json の Bufferify 周りの設定は下記のようになります。

```json
  "browserify": {
    "transform": [
      "browserify-shim"
    ]
  },
  "browser": {
    "bootstrap": "./node_modules/bootstrap/dist/js/bootstrap.js",
    "popper.js": "./node_modules/popper.js/dist/umd/popper.js",
    "jquery": "./node_modules/jquery/dist/jquery.js"
  },
  "browserify-shim": {
    "jquery": "$",
    "popper.js": "$",
    "bootstrap": {
      "exports": "$",
      "depends": [
        "jquery:jQuery",
        "popper.js:Popper.js"
      ]
    }
  },
```

## 確認方法

まず，Javascript Console でエラーが出ていないことを確認しましょう。

次に source/index.html.slim に下記を追記してボタンを配置してみましょう。

```slim
.container
	button type="button" class="btn btn-danger"
		Danger
```

ビルドしてサーバーを立ち上げます。

```
$ cd (Middleman のディレクトリ)
$ middleman build
$ middleman server
```

[http://localhost:4567](http://localhost:4567) を表示した時に赤いボタンが表示されていれば成功です。

