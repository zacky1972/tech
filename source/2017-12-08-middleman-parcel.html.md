---
title: Middleman v4 で parcel を使ってみる
---
# Middleman v4 で parcel を使ってみる

Javascript 界隈の進化は早く，webpack 全盛時代から今度は parcel だと！ さっそく parcel を使ってみました。

## 前提: Middleman と yarn の設定

```
$ gem install middleman
$ gem install slim
$ middleman init (プロジェクト名) -T yterajima/middleman-slim
```

最初の Middleman インストール時に次の設定にしました。

* Asset Pipe Line をオフにしました
* Compass, LiveReload はインストールしています
* config.ru を有効にしました。Heroku などにデプロイするときに使います

また，最初から yarn にしたので，yarn をインストールした後，次のコマンドで package.json を初期化しています。

```
$ cd (Middlemanのディレクトリ)
$ yarn init
```

たくさん質問されます。良きように設定してください。

## 手順

1. yarn で parcel をインストールする
2. .gitignore を編集する
3. config.rb で，相対パス指定にして external_pipeline の設定に parcel を追加する

## 1. yarn で parcel をインストールする

次のコマンドを実行します。

```
$ yarn global add parcel-bundler
```

## 2. .gitignore を編集する

.gitignore に次の記述を足します。

```
# Ignore yarn log
yarn-error.log

# Ignore node_modules
/node_modules

# Ignore dist
dist/
```

## 3. config.rb で，相対パス指定にして external_pipeline の設定に parcel を追加する

ここが本題。config.rb に次の記述を足します。

```ruby
# 相対パス指定にする
activate :relative_assets

# parcel を呼び出す設定にする
activate :external_pipeline, {
	name: :parcel,
	command: "parcel build source/javascripts/all.js --out-dir build/javascripts/",
	source: './build',
	latency: 1
}
```

