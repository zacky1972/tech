---
title: Middleman v4 で Browserify を使えるようにする
---
# Middleman v4 で Browserify を使えるようにする

Browserify によって npm によるパッケージ管理をブラウザでも利用できるようになります。

## 参考記事

* [Middleman 4 の External Pipeline（外部パイプライン）を試す](https://whiskers.nukos.kitchen/2016/10/07/middleman-external-pipeline.html)
* [Middleman 4 の External Pipeline を活用した Sass のプリコンパイルと Browserify のバンドル](https://whiskers.nukos.kitchen/2016/10/13/middleman-external-pipeline-server-build.html)

## 前提

Middleman に npm と gulp をインストールしておきます。

1. [GitHub Pages で Middleman v4 を使う](https://zacky1972.github.io/tech/2017/11/04/middleman.html)
2. [Middleman v4 で npm を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/01-middleman-npm.html)
3. [Middleman v4 で gulp を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/02-middleman-gulp.html)

## 手順

1. npm で Browserify をインストールする
2. npm で vinyl-source-stream をインストールする
3. gulpfile.js を書き換える
4. config.rb を書き換える
5. .gitignore に .tmp を加える
6. layout.slim を書き換える

## 1. npm で Browserify をインストールする

```
$ cd (Middleman のディレクトリ)
$ npm install browserify --save-dev
```

## 2. npm で vinyl-source-stream をインストールする

```
$ cd (Middleman のディレクトリ)
$ npm install vinyl-source-stream --save-dev
```

## 3. gulpfile.js を書き換える

gulpfile.js を次のように書き換えます。

```javascript
var gulp = require('gulp');
var source = require('vinyl-source-stream');
var browserify = require('browserify');

var paths = {
	srcPath: 'source/javascripts/all.js',
	destFileName: 'javascripts/bundle.js',
	destPath: '.tmp/dist'
}

var b = browserify({
	entries: paths.srcPath,
	cache: {},
	packageCache: {}
});

gulp.task('default', ['build']);
gulp.task('build', bundle);
gulp.task('watch', function(){
  //
});

function bundle() {
	return b.bundle()
    .pipe(source(paths.destFileName))
		.pipe(gulp.dest(paths.destPath));
}
```

ポイントは次の通り。

* 2行目の require('browserify') で Browserify を読み込む
* 拡張性のため，新しいタスク build を作って，タスク default が build を実行するようにする
* タスク build では function bundle を呼び出す
* タスク build の中で vinyl-source-stream と Browserify を呼び出して結合する
* Browserify は source/javascript/all.js を読み込むようにする


## 4. config.rb を書き換える

config.rb に書かれている gulp の設定を次のように書き換えます。

```ruby
activate :external_pipeline,
  name: :gulp,
  command: build? ? './node_modules/gulp/bin/gulp.js build' : './node_modules/gulp/bin/gulp.js watch',
  source: ".tmp/dist",
  latency: 0.25

configure :build do
  ignore /stylesheets\/.*\.scss/
  ignore /javascripts\/(?!bundle).*\.js/
end
```

ポイントは次の通りです。

* gulp のタスクを build と watch を呼び出す
* source を .tmp/dist に切り替える
* scss と javascript の変換を gulp だけにさせる (Rendererを止める)

## 5. .gitignore に .tmp を加える

.gitignore に次の記述を足します。

```
# Ignore .tmp
.tmp/
```

## 6. layout.slim を書き換える

layout.slim を次の記述を書き換えます。

書き換え前

```slim
    == javascript_include_tag  "all"
```

書き換え後

```slim
    == javascript_include_tag  "bundle"
```

## 確認方法

次のコマンドを実行してエラーがないことを確認します。

```
$ cd (Middleman のディレクトリ)
$ middleman build
```

次に，生成された html ファイル (たとえば build/index.html) を参照し，bundle.\*.js を読み込む設定になっていれば成功です。

