---
title: Elixir のアセンブリコードを出力する
---
# Elixir のアセンブリコードを出力する

Elixir の BEAM アセンブリコードを出力する方法について。

## 参考文献

* [Elixir や Erlang の beam ファイルを逆アセンブル、逆コンパイルする方法](https://qiita.com/tatsuya6502/items/fa142cb51824bb72c910)

## やり方

Elixir のバージョン1.6.1で試したところ，次のようにすればBEAMアセンブリコードを出力できた。

```bash
$ export ERL_COMPILER_OPTIONS=\'S\'
$ elixirc (出力したいファイル).ex
```

エラーが出力されるものの，`(出力したいファイル).ex.S` というファイルが出来上がっている。

## おまけ1: BEAMコードのダンプ

Mac の場合，次のようにする。

```bash
$ xxd (出力したいファイル).beam
```

`xxd` を使うと，16進数とASCII codeでダンプしてくれる。

## おまけ2: Erlang BEAM Instruction Set

* [Erlang BEAM Instruction Set](http://www.cs-lab.org/historical_beam_instruction_set.html)
* [Erlang BEAM Instruction Set (日本語訳つき)](https://gist.github.com/oskimura/5a80512eb559c29c9063)

しかしこれには具体的なバイトコードの数値が記載されていない。なので，現在リバースエンジニアリングして解読しているところ。

昔のZ80機械語プログラミングをしていた頃を思い出して，逆にワクワクしている。
