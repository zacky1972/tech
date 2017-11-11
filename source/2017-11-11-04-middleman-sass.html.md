---
title: Middleman v4 + gulp + Browserify で Sass/Scss を使えるようにする
---
# Middleman v4 + gulp + Browserify で Sass/Scss を使えるようにする

Sass/Scss は保守性を向上させた CSS と思えばいいです。変数や関数が記述できるようになります。

Middleman はもともと Renderer によって Sass/Scss を CSS に変換していますが，外部パイプラインにして gulp + Browserify の設定にすると，Renderer を止めてしまうので，gulp + Browserify の環境下で Sass/Scss を CSS に変換してやる必要があります。

## 参考記事

* [Middleman 4 の External Pipeline を活用した Sass のプリコンパイルと Browserify のバンドル](https://whiskers.nukos.kitchen/2016/10/13/middleman-external-pipeline-server-build.html)

## 前提

Middleman に npm, gulp, Browserify をインストールしておきます。

1. [GitHub Pages で Middleman v4 を使う](https://zacky1972.github.io/tech/2017/11/04/middleman.html)
2. [Middleman v4 で npm を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/01-middleman-npm.html)
3. [Middleman v4 で gulp を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/02-middleman-gulp.html)
4. [Middleman v4 で Browserify を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/03-middleman-browserify.html)

## 手順

1. npm で gulp-sass をインストールする
2. gulpfile.js を書き換える
3. source/stylesheets/site.css.scss を site.scss にリネームする

## 1. npm で gulp-sass をインストールする

次のコマンドで gulp-sass と node-neat をインストールします。

```
$ cd (Middleman のディレクトリ)
$ npm install gulp-sass node-neat --save-dev
```

## 2. gulpfile.js を書き換える

gulpfile.js を次のように書き換えます。

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
gulp.task('build', ['sass', 'bundle']);
gulp.task('watch', function(){
  //
});
gulp.task('bundle', jsBundle);
gulp.task('sass', sassPreCompile);

function jsBundle() {
	return b.bundle()
    .pipe(source(jsConf.destFileName))
		.pipe(gulp.dest(jsConf.destPath));
}

function sassPreCompile(){
  gulp.src(cssConf.srcPath)
    .pipe(sass({
    	includePaths: cssConf.destFileName
    }))
    .pipe(gulp.dest(cssConf.destPath));
}
```

## 3. source/stylesheets/site.css.scss を site.scss にリネームする

```
$ cd (Middleman のディレクトリ)/source/stylesheets/
$ mv site.css.scss site.scss
```

## 確認方法

次のコマンドを実行してエラーがないことを確認します。

```
$ cd (Middleman のディレクトリ)
$ middleman build
```

次のような実行結果に次のような記述があれば成功です。

```
create  build/stylesheets/site-d0be9709.css
```

ただし，d0be9709 は実行状況により変化します。

