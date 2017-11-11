---
title: Middleman v4 で Browserify を使えるようにする
---
# Middleman v4 で Browserify を使えるようにする

Browserify によって npm によるパッケージ管理をブラウザでも利用できるようになります。

## 参考記事

* [Middleman 4 の External Pipeline（外部パイプライン）を試す](https://whiskers.nukos.kitchen/2016/10/07/middleman-external-pipeline.html)

## 前提

Middleman に npm と gulp をインストールしておきます。

1. [GitHub Pages で Middleman v4 を使う](https://zacky1972.github.io/tech/2017/11/04/middleman.html)
2. [Middleman v4 で npm を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/01-middleman-npm.html)
3. [Middleman v4 で gulp を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/02-middleman-gulp.html)

## 手順

1. npm で Browserify をインストールする
2. gulpfile.js を書き換える

## 1. npm で Browserify をインストールする

```
$ cd (Middleman のディレクトリ)
$ npm install browserify --save-dev
```

## 2. gulpfile.js を書き換える

gulpfile.js を次のように書き換えます。

```javascript
var gulp = require('gulp');
var browserify = require('browserify');

gulp.task('default', ['build']);
gulp.task('build', function() {
	//
});
gulp.task('watch', function(){
  //
});
```

ポイントは次の通り。

* 2行目の require('browserify') で Browserify を読み込む
* 拡張性のため，新しいタスク build を作って，タスク default が build を実行するようにする

次のコマンドを実行してエラーがなければ成功です。

```
$ cd (Middleman のディレクトリ)
$ middleman build
```
