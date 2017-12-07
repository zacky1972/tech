---
title: Middleman v4 で npm から yarn に移行する
---
# Middleman v4 で npm から yarn に移行する

Javascript 界隈の進化は早く，npm (Node Packeged Modules) よりベターな yarn というパッケージ管理ツールが登場しています。さっそく npm から yarn に乗り換えてみました。

## 手順

1. yarn をインストールする
2. 念のため node_modules を消去しておく
3. yarn install を実行する
4. config.rb で "npm run" としている箇所を "yarn run" に置き換える 

## 1. yarn をインストールする

公式ガイドを参照ください。

* [Installation](https://yarnpkg.com/en/docs/install)

私は Mac なので，HomeBrew でインストールしました。

```
$ brew install yarn
```

## 2. 念のため node_modules を消去しておく

```
$ cd (Middlemanのディレクトリ)
$ rm -rf node_modules
```

## 3. yarn install を実行する

```
$ cd (Middlemanのディレクトリ)
$ yarn install
```

npm より相当高速にインストールされます。

## 4. config.rb で "npm run" としている箇所を "yarn run" に置き換える 

エディタの置換機能をお使いください。

## 確認方法

次のコマンドを実行してエラーが出なければ大丈夫です。

```
$ cd (Middlemanのディレクトリ)
$ middleman build
```

