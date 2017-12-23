---
title: middleman-iepab 公開しました。
---
# middleman-iepab 公開しました。

middleman v4 では external pipeline を呼び出すのがビルドより前にしかできないのですが，たまにビルドより後に呼び出したい時があります。

たとえば，asset_hash 相当の処理を rev と rev-replace を実行する gulp タスクの external pipeline で行いたい場合，rev-replace による \*.html の書き換えはビルドより後でしか行えないので，既存の external pipeline ではうまく実現できませんでした。

そこで，middleman-iepab (invoke external pipeline after build) を開発しました。

* [rubygems の公開ページ](https://rubygems.org/gems/middleman-iepab)
* [ソースコード(GitHub)](https://github.com/zacky1972/middleman-iepab)

はじめて middleman のカスタム拡張を作ったので，いろいろ不手際があるかもしれません。

インストール方法:

Middleman の Gemfile に `gem "middleman-iepab"` を追加して `bundle install` を実行する

設定方法:

config.rb を次のように設定すると，ビルド終了後に `hello` と表示されます。

```ruby
activate :iepab, {
  name: :echo,
  command: "echo hello",
  source: "./source",
  latency: 1
}
```

この記法と機能は，external pipeline と同じです。違いは，**ビルド後に** external pipeline を呼び出すという点です。

