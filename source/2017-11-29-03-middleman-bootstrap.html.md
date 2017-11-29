---
title: Middleman v4 + webpack の上に Bootstrap v4  を使えるようにする
---
# Middleman v4 + webpack の上に Bootstrap v4 を使えるようにする

## 前提

Middleman に npm, Webpack をインストールしておきます。

1. [GitHub Pages で Middleman v4 を使う](https://zacky1972.github.io/tech/2017/11/04/middleman.html)
2. [Middleman v4 で npm を使えるようにする](https://zacky1972.github.io/tech/2017/11/11/01-middleman-npm.html)
3. [Middleman v4 で Webpack を使えるようにする](https://zacky1972.github.io/tech/2017/11/29/01-middleman-webpack.html)
4. [Middleman v4 + webpack の上に jQuery を使えるようにする](https://zacky1972.github.io/tech/2017/11/29/02-middleman-jquery.html)

## 手順

1. npm で Bootstrap v4 と Popper.js をインストールする
2. npm で必要なパッケージをインストールする
3. site.js に Bootstrap を追加する
4. webpack.config.js に Bootstrap の CSS をコピーする設定を追加する
5. layout.slim にレスポンシブメタタグと bundle を追加する

## 1. npm で Bootstrap v4 と Popper.js をインストールする

Bootstrap の2017年11月12日現在のバージョンは v4.0.0-beta.2 です。

次のコマンドを実行します。

```
$ cd (Middleman のディレクトリ)
$ npm install --save bootstrap@4.0.0-beta.2 popper.js
```

Popper.js はツールチップです。Bootstrap v4 が Popper.js を要求するのでインストールしました。

## 2. npm で必要なパッケージをインストールする

```
$ cd (Middleman のディレクトリ)
$ npm install extract-text-webpack-plugin css-loader style-loader sass-loader precss postcss-loader file-loader node-sass --save-dev
```

## 3. site.js に Bootstrap を追加する

source/javascripts/site.js の require('jquery') 以下を次のようにします。

```javascript
require('jquery');
require('popper.js');
require('bootstrap');
```

## 4. webpack.config.js に Bootstrap の CSS をコピーする設定を追加する

webpack.config.js を次のようにします。

```javascript
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const webpack = require('webpack');

const bootstrap = {
	entry: [
		__dirname + '/node_modules/bootstrap/scss/bootstrap.scss'
	],
	output: {
		filename: 'bundle.css',
		path: __dirname + '/build/stylesheets'
	},
	module: {
		rules: [
			{
				test: /\.scss$/,
				use: ExtractTextPlugin.extract({
					fallback: 'style-loader',
					use: [
						'css-loader',
						{
							loader: 'postcss-loader',
							options: {
								plugins: function() {
									return [
										require("precss"),
										require('autoprefixer')
									];
								}
							}
						},
						'sass-loader'
					]
				})
			},
			{
				test: /\.css$/,
				loader: ExtractTextPlugin.extract('css-loader')
			},
			{
				test: /\.(woff|woff2|eot|ttf|svg)$/,
				loader: 'file-loader?name=../font/[name].[ext]'
			}
		]
	},
	plugins: [
		new ExtractTextPlugin('../stylesheets/bundle.css')
	]
}

const sitejs = {
	entry: [
		'./source/javascripts/site.js'
	],
	output: {
		filename: 'bundle.js',
		path: __dirname + '/build/javascripts'
	},
	module: {
		loaders: [
			{
				test: /\.scss$/,
				loaders: ['style-loader', 'css-loader', 'sass-loader']
			},
			{
				test: /\.(woff|woff2|eot|ttf|svg)$/,
				loader: 'file-loader?name=../font/[name].[ext]'
			}
		]
	},
  plugins: [
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      'window.jQuery': 'jquery',
      Popper: ['popper.js', 'default']
    })
  ]
};

module.exports = [sitejs, bootstrap];
```

## 5. layout.slim にレスポンシブメタタグと bundle を追加する

source/layouts/layout.slim の head 部分を下記のようにします。

```slim
  head
    meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible"
    meta charset="utf-8"
    meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"
```

さらに stylesheet_link_tag の部分を下記のようにします。

```slim
    == stylesheet_link_tag "bundle", :site
```

## 確認方法

まず，Javascript Console でエラーが出ていないことを確認しましょう。

次に source/index.html.slim に下記を追記してボタンを配置してみましょう。

```slim
.container
    button type="button" class="btn btn-danger"
        Danger
```

ビルドしてサーバーを立ち上げます。

```
$ cd (Middleman のディレクトリ)
$ middleman build
$ middleman server
```

[http://localhost:4567](http://localhost:4567) を表示した時に赤いボタンが表示されていれば成功です。
