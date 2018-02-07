---
title: ウェブエンジニアのみなさん！ WordPress を捨てて 保守性が高くセキュリティも安心な Middleman でウェブサイトを構築しようよ！ ビルドが速くてウェブパフォーマンスが高くなるぞ！
---
# ウェブエンジニアのみなさん！ WordPress を捨てて 保守性が高くセキュリティも安心な Middleman でウェブサイトを構築しようよ！ ビルドが速くてウェブパフォーマンスが高くなるぞ！

* Middleman はブログなどの静的なウェブサイトを構築する Ruby ベースのツールです。Ruby の記述力を生かした，保守性の高いウェブページを構築することができます。また静的なので，WordPress のようなセキュリティ上の攻撃を受けるリスクが相当軽減されます。
* Middleman v4 (version 4) では，外部ツールを呼び出す External Pipeline という仕組みがあり，Javascript ツールなどを呼び出してウェブページをビルドすることができます。
* parcel は最小限の設定だけで，とてもいい感じかつ高速に HTML/CSS/Javascript をビルド・パックしてくれる小粋な Javascript ツールです。
* gulp は，ワイルドカードによるファイル指定と，ファイルの依存関係を設定して，外部ツールを呼び出すことができるシンプルな Javascript ツールです。

そこで鍵となるのが，私が自作した gulp-parcel と middleman-iepab です。

設定が最小限で済む parcel を，シンプルにファイルの依存関係を記述できる gulp から呼び出す gulp-parcel を使うと，parcel の高い性能を引き出しつつ，他の Javascript ツールと協調させることができます。Middleman の External Pipeline から gulp-parcel を含む gulp のツールチェーンを呼び出して活用すると，ビルドが速くてウェブパフォーマンスの高いウェブサイトの構築ができます。

一方，middleman-iepab はビルド後に External Pipeline を呼び出すことができるだけのシンプルなツールですが，実は parcel の機能を使うのに欠かせません。

本稿では Middleman のツールチェーンを構築する基本と応用についてご紹介します。

## 前提条件

* Ruby 2.4系がインストール済であるものとします。(2.3以前や，2.5系は未検証)
* Mac で Homebrew 環境であるものとします。その他のパッケージ管理システムや Windows は使っていないので，検証してくださる方を求めます！
* Javascript のパッケージ管理システムとしては，npm ではなく yarn を採用します。
* ERB や Haml 等ではなく，Slim を採用しています。

## Middleman v4 と Slim のインストール

```bash
$ gem install middleman slim
```

## Middleman プロジェクトの新規作成

```bash
$ cd (プロジェクトのディレクトリ)
$ middleman init . -T yterajima/middleman-slim
Do you want to use the Asset Pipeline? n
Do you want to use Compass? y
Do you want to use LiveReload? y
Do you want a Rack-compatible config.ru file? y
```

各選択肢について説明します。

* Asset Pipeline は，Middleman v3 以前で標準だった機能で，Ruby on Rails に準じるツールチェーンを構築するためのものです。今回は，Javascript ベースのツールチェーンを構築するための仕組みである External Pipeline だけを用いるので，用いませんでした。
* Compass は，CSS を構造化して活用しやすくするための仕組みです。インストールしておいて損はないでしょう。
* LiveReload は，ローカルプレビューを表示しながら HTML/CSS/JS 等のファイルを更新した時に，ウェブブラウザに自動でリロードをかけて最新版を表示してくれるようにするツールです。設定で有効・無効を切り替えられるので，インストールしておいて損はないでしょう。
* config.ru は Rack 互換の設定ファイルを出力する機能で，Heroku 等にデプロイする時に使います。

## Javascript パッケージ管理システムの初期化

```bash
$ yarn init
question name (): 
question version (1.0.0): 
question description: 
question entry point (index.js): 
question repository url (): 
question author (): 
question license (MIT): 
question private: 
```

良きように設定してください。

* `question name ():` プロジェクト名を設定します 
* `question version (1.0.0):` 初期バージョン番号を設定します
* `question description:` プロジェクトの説明文を設定します
* `question entry point (index.js):` Javascript ツールのパッケージにした時に，クライアントから最初に呼ばれるプログラム名(エントリポイント)を設定します。今回は特に意味がありません。
* `question repository url ():` Git のレポジトリの URL を設定します。このコマンドの実行前に git の設定をしていれば，自動で設定されます。
* `question author ():` 著者名とメールアドレスを設定します。こんな感じ: `Susumu Yamazaki <hoge@foo.com>`
* `question license (MIT):` ライセンスを設定します。公開する場合はよく考えて選びましょう。
* `question private:` 非公開にするか公開するかを設定します。非公開にしておくと，誤って yarn publish とかした時の事故を防げます。



`.gitignore` を編集しておきましょう。これは Git の管理下に置かないファイルを設定します。

```.gitignore
# See http://help.github.com/ignore-files/ for more about ignoring files.
#
# If you find yourself ignoring temporary files generated by your text editor
# or operating system, you probably want to add a global ignore instead:
# git config --global core.excludesfile ~/.gitignore_global

# Ignore bundler config
/.bundle

# Ignore the build directory
/build

# Ignore cache
/.sass-cache
/.cache

# Ignore .DS_store file
.DS_Store

# Ignore yarn log
yarn-error.log

# Ignore yarn.lock
yarn.lock

# Ignore node_modules
/node_modules

# Ignore dist
dist/
```

## ここまでの動作確認

ローカルプレビューは次のコマンドを入力します。

```bash
$ bundle exec middleman serve
``` 

ウェブブラウザで [http://localhost:4567](http://localhost:4567) を開くと，CSS アニメーションを伴った Middleman のデモページが閲覧できます。

次のコマンドを入力すると，```build``` ディレクトリ以下に静的ページがビルドされます。

```bash
$ bundle exec middlman build
```

`build` 以下をウェブサイトにアップロードする(デプロイする)ことで，手軽に静的ウェブサイトが構築できます。あとで説明しますが，このデプロイ作業を1行のコマンドで実行できるようにする設定もできます。FTP, ssh + rsync のほか，GitHub Pages にも対応できます。

## parcel のインストール

いよいよ parcel を使ってみます。インストールは次のように行います。

```bash
$ yarn add parcel-bundler
```

## config.rb の修正

parcel でビルドできるように `config.rb` の設定を修正します。アセットへの URL が相対パスになるようにします。

`config.rb` の `require 'slim'` の後に次の行を追加します。 

```ruby
activate :relative_assets
```
 
## parcel によるプレビュー

Middleman でビルドしたページを parcel でビルドしてローカルプレビューしてみましょう。

```bash
$ bundle exec middleman build
$ yarn parcel --no-cache build/index.html
```

ウェブブラウザで [http://localhost:1234](http://localhost:1234) を開くと Middleman のデモページが閲覧できます。

## parcel によるビルド

Middleman でビルドしたページを parcel でさらにビルドするには次のようにします。

```bash
$ bundle exec middleman build
$ yarn parcel build build/index.html --out-dir dist --public-url ./
```

`dist` 以下をウェブサイトにアップロードする(デプロイする)ことで，手軽に静的ウェブサイトが構築できます。これも1行のコマンドで実行できるようにできます(後述)。

## parcel で何をしているのか？

2つのディレクトリ `build` と `dist` の中身を比べてみましょう。次のことに気づきます。

* CSS と JS のディレクトリは `dist` ではルートになっています。parcel により CSS と JS の全てのファイルを自動的に1つにまとめてくれるので，ディレクトリに分ける必要はないという判断でしょう。
* とくに何も設定しなくても，CSS と JS や画像のファイル名が `dist` ではハッシュ化された名前になっています。これにより，更新された時にキャッシュされることを回避してくれます。
* CSS と JS のコードを読んでみると， `dist` では自動的に最小化してくれています。これを抑制するには parcel に `--no-minify` オプションをつけます。

## Middleman から parcel をビルドしよう

ビルドするたびに2回コマンドを打ち込むのは面倒ですね。そこで，Middleman の External Pipeline を使って parcel を呼び出してみましょう。

Middleman のマニュアル通りに External Pipeline を使うと，`config.rb` の `# Build-specific configuration` の直後を次のようにします。

```ruby
# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  activate :external_pipeline,
  name: :parcel,
    command: "yarn parcel build build/index.html --out-dir dist --public-url ./", 
    source: "build",
    latency: 1
end
```

このあと，次のコマンドを入力して Middleman のビルドを実行してみましょう。

```bash
$ bundle exec middleman build
```

すると，一見正しく実行できるように見えます。

```bash
$ bundle exec middleman build
== Executing: `yarn parcel build build/index.html --out-dir dist --public-url ./`
== External: yarn run v1.3.2
== External: $ .../node_modules/.bin/parcel build build/index.html --out-dir dist --public-url ./
== External: ⏳  Building...
== External: ⏳  Building index.html...
== External: ⏳  Building site.css...
== External: ⏳  Building all.js...
== External: ⏳  Building middleman-logo.svg...
== External: ⏳  Building jquery.js...
== External: ⏳  Building browser.js...
== External: ✨  Built in 1.80s.
== External: Done in 3.23s.
   identical  build/stylesheets/site.css
   identical  build/stylesheets/site.css
   identical  build/images/middleman-logo.svg
   identical  build/javascripts/all.js
   identical  build/index.html
   identical  build/index.html
Project built successfully.
```

でもよく見ると先に parcel を実行した後，Middleman がビルドしていますね。試しに下記のコマンドを実行して `build` と `dist` を消してからビルドしてみましょう。

```bash
$ rm -rf build dist
$ bundle exec middleman build
```

今度は下記のようにエラーで止まってしまいます。

```bash
$ rm -rf build dist
$ bundle exec middleman build
== Executing: `yarn parcel build build/index.html --out-dir dist --public-url ./`
== External: yarn run v1.3.2
== External: $ .../node_modules/.bin/parcel build build/index.html --out-dir dist --public-url ./
== External: ⏳  Building...
== External: 🚨  Cannot find module '.../build/index.html' from '.'
...
error Command failed with exit code 1.                                         
== External: info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.
== External: Command failed with non-zero exit status
```

External Pipeline の実行と Middleman のビルドの実行の順番を入れ替えたいですね。でも，Middleman の標準機能では実現できません。

## middleman-iepab の導入

そこで，私は Middleman のビルドの後に External Pipeline の実行をするカスタム拡張 middleman-iepab を開発しました。ちなみに iepab というのは Invoke External Pipeline after Buidliing の略です。機能そのまんまですね。

まず，`Gemfile` の末尾に次の記述を追加しましょう。

```Gemfile
gem 'middleman-iepab', '>= 0.1.1'
```

その後，次のコマンドを実行します(カスタム拡張を追加するなど `Gemfile` を変更した場合は必ず実行します)。

```bash
$ bundle install
```

エラーがなく完了したことを確認し，`config.rb` の先ほどの記述を次のように変更します。

```ruby
# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  activate :iepab,
  name: :parcel,
    command: "yarn parcel build build/index.html --out-dir dist --public-url ./", 
    source: "build",
    latency: 1
end
```

その後，おもむろに Middleman のビルドを実行しましょう。

```bash
$ bundle exec middleman build
```

今度は次のように正常に実行できます！

```bash
$ bundle exec middleman build
      create  build/stylesheets/site.css
      create  build/images/middleman-logo.svg
      create  build/javascripts/all.js
      create  build/index.html
== Executing: `yarn parcel build build/index.html --out-dir dist --public-url ./`
== External: yarn run v1.3.2
warning package.json: No license field                                         
== External: $ .../node_modules/.bin/parcel build build/index.html --out-dir dist --public-url ./
== External: ⏳  Building...
== External: ⏳  Building index.html...
== External: ⏳  Building site.css...
== External: ⏳  Building all.js...
== External: ⏳  Building middleman-logo.svg...
== External: ⏳  Building jquery.js...
== External: ⏳  Building browser.js...
== External: ✨  Built in 1.53s.
== External: Done in 2.22s.
Project built successfully.
```

なお，現状の middlman-iepab は watch モード (`middleman serve`) に対応できていません。現在，対応できるように調査をしているところです。

## 複数ページのビルド

次のコマンドを入力して複数ページがある状態にしてみましょう。

```bash
$ cp source/index.html.slim source/index2.html.slim
$ mkdir source/about
$ cp source/index.html.slim source/about/index.html.slim
```

これらをビルドしようと思っても1つの html ファイルしか parcel でビルドされません。

```bash
$ bundle exec middleman build
      create  build/stylesheets/site.css
      create  build/javascripts/all.js
      create  build/images/middleman-logo.svg
      create  build/index.html
      create  build/index2.html
      create  build/about/index.html
== Executing: `yarn parcel build build/index.html --out-dir dist --public-url ./`
== External: yarn run v1.3.2
warning package.json: No license field                                         
== External: $ .../node_modules/.bin/parcel build build/index.html --out-dir dist --public-url ./
== External: ⏳  Building...
== External: ⏳  Building index.html...
== External: ⏳  Building site.css...
== External: ⏳  Building all.js...
== External: ⏳  Building middleman-logo.svg...
== External: ⏳  Building jquery.js...
== External: ⏳  Building browser.js...
== External: ✨  Built in 1.53s.
== External: Done in 2.19s.
Project built successfully.
$ ls dist/
815aa32b3c46be9eaeee563dc5303036.css  da24f1e92e1197f7cdfcda9996f918d4.js
d5b2b1aa06bfb67190f67a5ce4370081.svg  index.html
```

そこで私が開発したのが gulp-parcel です。gulp-parcel をインストールするには次のコマンドを実行します。

```bash
$ yarn add gulp gulp-coffee gulp-parcel
```

次のように gulpfile.coffee を作成します。

```coffee
gulp = require 'gulp'
parcel = require 'gulp-parcel'

gulp.task 'build', () ->
  gulp.src 'build/**/*.html', {read:false}
    .pipe parcel({outDir: 'dist', publicURL: './'}, {source: 'build'})
    .pipe gulp.dest('dist')
```

そして `config.rb` の先ほどの記述を次のように変更します。

```ruby
# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  activate :iepab,
  name: :gulp,
    command: "yarn gulp build", 
    source: "build",
    latency: 1
end
```

ではビルドしてみましょう。

```bash
$ bundle exec middleman build
   identical  build/stylesheets/site.css
   identical  build/images/middleman-logo.svg
   identical  build/javascripts/all.js
   identical  build/about/index.html
   identical  build/index.html
   identical  build/index2.html
== Executing: `yarn gulp build`
== External: yarn run v1.3.2
warning package.json: No license field                                         
== External: $ .../node_modules/.bin/gulp build
== External: [20:12:34] Requiring external module coffeescript/register
== External: [20:12:35] Using gulpfile ~/github/enPiT-everi/gulpfile.coffee
== External: [20:12:35] Starting 'build'...
== External: ⏳  Building...
== External: ⏳  Building index.html...
== External: ⏳  Building site.css...
== External: ⏳  Building all.js...
== External: ⏳  Building middleman-logo.svg...
== External: ⏳  Building jquery.js...
== External: ⏳  Building browser.js...
== External: ✨  Built in 903ms.
== External: ⏳  Building...
== External: ⏳  Building index2.html...
== External: ⏳  Building site.css...
== External: ⏳  Building all.js...
== External: ⏳  Building middleman-logo.svg...
== External: ⏳  Building jquery.js...
== External: ⏳  Building browser.js...
== External: ✨  Built in 95ms.
== External: ⏳  Building...
== External: ⏳  Building index.html...
== External: ⏳  Building site.css...
== External: ⏳  Building all.js...
== External: ⏳  Building middleman-logo.svg...
== External: ⏳  Building jquery.js...
== External: ⏳  Building browser.js...
== External: ✨  Built in 142ms.
== External: [20:12:36] Finished 'build' after 1.18 s
== External: Done in 2.61s.
Project built successfully.
```

※ 同じ css, js, 画像 が3回もビルドされている点が，まだまだ最適化の余地がありますね。

これにより 3つの html ファイルがビルドされています。

```bash
$ ls -R dist
815aa32b3c46be9eaeee563dc5303036.css  da24f1e92e1197f7cdfcda9996f918d4.js
about         index.html
d5b2b1aa06bfb67190f67a5ce4370081.svg  index2.html

dist/about:
815aa32b3c46be9eaeee563dc5303036.css  da24f1e92e1197f7cdfcda9996f918d4.js
d5b2b1aa06bfb67190f67a5ce4370081.svg  index.html
```

※ `dist/about` にも css, js, 画像 が配置されている点が，まだまだ改善の余地がありますね。

## Javascript のライブラリを使ってみよう: jQuery の場合

