---
title: gulp-parcel 公開しました
---
# gulp-parcel 公開しました

parcel を gulp から呼び出すプラグイン gulp-parcel を公開しました。

* [npmjs の公開ページ](https://www.npmjs.com/package/gulp-parcel)
* [ソースコード(GitHub)](https://github.com/zacky1972/gulp-parcel)

はじめて gulp プラグインを作ったので，いろいろ制約があります。

* 入力となる gulp.src ではファイルを1つしか指定してはならず，かつ read:false をつけないといけない
* ワーキングディレクトリに .tmp-gulpcompile-xxx というディレクトリを作成し，削除するので，同名のファイルがあるとエラーになったり，消されてしまったりする

インストール方法:

npm の場合

```bash
$ npm install --global parcel-bundler
$ npm install --save-dev gulp-parcel
```

yarn の場合

```bash
$ yarn global add parcel-bundler
$ yarn add --dev gulp-parcel
```

使い方

gulpfile.coffee

```coffee
parcel = require 'gulp-parcel'

gulp.task 'build:js', () ->
  gulp.src 'source/javascripts/all.js', {read:false}
    .pipe parcel(['build'])
    .pipe gulp.dest('build/javascripts/')
```

こうすると，source/javascripts/all.js をエントリポイントとして parcel を起動し，build/javascripts/ 以下に展開します。

