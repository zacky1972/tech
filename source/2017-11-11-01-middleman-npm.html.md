---
title: Middleman v4 で npm を使えるようにする
---
# Middleman v4 で npm を使えるようにする

npm は Node Packaged Modules の略で，主にフロントエンド周りのパッケージ管理ツールです。Middleman v4 では外部パイプライン(external_pipeline)で npm を使ってパッケージ管理をするのが主流となってきています。

Middleman で npm を使うには次のことをします。

1. Middleman をインストールしたディレクトリ上で npm init を実行する
2. .gitignore に node_modules を加える

## 1. Middleman をインストールしたディレクトリ上で npm init を実行する

Middleman をインストールしたディレクトリ上で npm init を実行します。

```
$ cd (Middlemanをインストールしたディレクトリ)
$ npm init
```

するとたくさん質問されます。

```
$ npm init
package name: (...) -> パッケージ名を入れる。デフォルトでよければ enter
version: (1.0.0) -> バージョン番号を入れる
description: () -> 説明文を入れる
entry point: (index.js) -> たぶんデフォルトでOK
test command: -> 入れなくて良さそう
git repository: (https://github.com/...) -> デフォルトでOK
keywords: -> 入れなくて良さそう
author: -> 自分の名前を入れる
license: (ISC) -> ライセンスは考えよう
About to write to .../package.json:
...
Is this ok? (yes) yes
```

適宜 package.json を編集してください。

## 2. .gitignore に node_modules を加える

npm は node_modules というディレクトリを作ってパッケージの内容を展開します。このディレクトリは git で管理する必要はありません。

.gitignore に下記の記述を足します。

```
# Ignore node_modules
node_modules/
```

