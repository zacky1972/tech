---
title: Elixir でバイナリをダンプしてみる
---
# Elixir でバイナリをダンプしてみる

とある longest march を敢行するプロジェクトが静かにスタート，第一歩として Elixir でバイナリをダンプしてみるプログラムを書いてみる。

## 参考文献

1. [Mix〜Elixir School](https://elixirschool.com/ja/lessons/basics/mix/)
2. [ドキュメント〜Elixir School](https://elixirschool.com/ja/lessons/basics/documentation/)
3. [仕様と型〜Elixir School](https://elixirschool.com/ja/lessons/advanced/typespec)
4. [モジュール〜Elixir School](https://elixirschool.com/ja/lessons/basics/modules/)
5. [12 入出力 - IO](http://elixir-ja.sena-net.works/getting_started/12.html)
6. [パターンマッチング〜Elixir School](https://elixirschool.com/ja/lessons/basics/pattern-matching/)
7. [制御構造〜Elixir School](https://elixirschool.com/ja/lessons/basics/control-structures/)
8. [関数〜Elixir School](https://elixirschool.com/ja/lessons/basics/functions/)
9. [6 バイナリ，文字列そして文字リスト - Binaries, strings and char lists](http://elixir-ja.sena-net.works/getting_started/6.html)
10. [Integer](https://hexdocs.pm/elixir/Integer.html)
11. [Elixir文字列まとめ](https://qiita.com/noco/items/f99007954972c9ef5e50)

## 最初にしたこと

```bash
$ mix new dump
* creating README.md
* creating .gitignore
* creating mix.exs
* creating config
* creating config/config.exs
* creating lib
* creating lib/dump.ex
* creating test
* creating test/test_helper.exs
* creating test/dump_test.exs

Your Mix project was created successfully.
You can use "mix" to compile it, test it, and more:

    cd dump
    mix test

Run "mix help" for more commands.
$ cd dump
$ git init
$ git add -A
$ git commit -m "first commit"
```

`README.md` を適当に変える。

作成したレポジトリは [https://github.com/zacky1972/dump](https://github.com/zacky1972/dump)

## モジュールの作成

作った Elixir プログラム `lib/dump.ex`

```elixir
defmodule Dump do
  @moduledoc """
  This provides the `dump/1` `dump_p/1` `dump_f/1` `dump_d/1` and `last2/1` functions. 
  """

  @doc """
  This dumps binary files to stdard output.

  ## Parameter

  - path: is data or a binary file path to dump.

  """
  @spec dump(Path.t()) :: String.t()
  def dump(path) do
    IO.puts dump_p(path)
  end

  @doc """
  This dumps binary files to String.

  ## Parameter

  - path: is data or a binary file path to dump.

  ## Examples

    iex> Dump.dump_p("./test/sample")
    "41 42 43 44 45 46 47 48\\n49 4A 4B 4C 4D 4E\\n\\n"

  """
  @spec dump_p(Path.t()) :: String.t()
  def dump_p(path) do
    {:ok, file} = File.open path, [:read]
    dump_f(file)
  end

  @doc """
  This dumps binary files to String.

  ## Parameter

  - file: is data or a binary file path to dump.

  """
  @spec dump_f(File.t()) :: String.t()
  def dump_f(file) do
    case IO.binread(file, 8) do
      {:error, reason} -> {:error, reason} 
      :eof -> "\n"
      data -> "#{dump_d(data)}\n#{dump_f(file)}"
    end
  end


  @doc """
  This dumps binary data to String.

  ## Parameters

  - data: is binary data to dump.

  ## Examples

    iex> Dump.dump_d(<<0, 1, 2, 3>>)
    "00 01 02 03"

  """
  @spec dump_d(binary) :: String.t()
  def dump_d(data) do
    case data do
      <<>> -> :ok
      <<x :: integer>> -> "0#{Integer.to_string(x, 16)}" |> last2  
      <<x :: integer, y :: binary>> -> "#{dump_d(<<x>>)} #{dump_d(y)}"
    end
  end

  @doc """
  This slices the last 2 chars.

  ## Parameters

  - string: is string to slice.

  ## Examples

    iex> Dump.last2("0123")
    "23"
  """
  @spec last2(String.t()) :: String.t()
  def last2(string) do
    String.slice(string, String.length(string) - 2, String.length(string))
  end
end
```

