---
title: GitHub Pages で Middleman v4 を使う
---
# GitHub Pages で Middleman v4 を使う

この Tech ブログは Middleman v4 を GitHub Pages 上に立ち上げました。忘れないように手順を記したいと思います。

参考にした記事: 

* [middleman で構築したサイトを GitHub Pages で公開するまでの流れをまとめてみた](http://d.hatena.ne.jp/osyo-manga/20140209/1391955805)
* [【middleman】slimのテンプレートでinitする](https://qiita.com/eichann/items/4b2d6e6027b77cd1d12c)
* [middlemanでブログを作ろう。インストールから初期設定まで（slimも少々）](http://www.mdesign-works.com/blog/web/tech-middleman-blog/)
* [WordPressを卒業しよう。GitHubとMiddlemanで作るTech Blog《エンジニアサイト誕生の裏側 後編》](http://engineer.recruit-lifestyle.co.jp/techblog/2015-10-05-engineer-portal-site-2/)

## 1. Middleman のプロジェクトの作成

まずはローカルに Middleman のプロジェクトを作成します。Middleman のインストールは簡単で，gem からインストールするだけです。

```
$ gem install middleman
$ middleman version
Middleman 4.2.1
```

Mac で「管理者権限がなくてインストールできないよ」みたいなエラー(下記)が出た時には，システムにインストールされている Ruby を使おうとしているということだと思いますので，rbenv 等を使ってお好きなバージョンの Ruby を利用することにしてください。

```
ERROR:  While executing gem ... (Gem::FilePermissionError)
    You don't have write permissions for the /Library/Ruby/Gems/2.0.0 directory.
```

Middleman のインストールに成功したら，下記のコマンドを実行してプロジェクトを生成します。

```
$ middleman init (プロジェクト名)
```

私の場合は Slim が使いたかったので，下記のようにして Slim のテンプレートを生成しました。

```
$ gem install slim
$ middleman init (プロジェクト名) -T yterajima/middleman-slim
```

途中で出る質問には全部 Yes と答えました。

```
Do you want to use the Asset Pipeline? yes
Do you want to use Compass? yes
Do you want to use LiveReload? yes
Do you want a Rack-compatible config.ru file? yes
```

その後，プロジェクト名で指定したディレクトリに移動します。

```
cd (プロジェクト名)
```

この時点で GitHub にプロジェクトを作成します。

次のコマンドで GitHub に接続します。

```
$ git init
$ git remote add origin (リモート先)
```

ディレクトリの内容を add/commit/push しておきましょう。

```
$ git add -A
$ git commit -m "initial commit"
$ git push -f origin master
```

## 2. サーバーの起動

プロジェクトディレクトリ上で，次のコマンドを入力するとサーバーが起動します。

```
$ middleman server
```

[http://localhost:4567/](http://localhost:4567/) にアクセスするとローカルプレビューを見ることができます。

## 3. ブログの導入

Gemfile に次の記述を足します。

```
gem 'middleman-blog', '~> 4.0'
```

Middleman では Gemfile を変更した後には，次のコマンドを実行します。

```
$ bundle install
```

次に config.rb に次のような記述を足します。

```
activate :blog do |blog|
  # ブログ機能のオプションを設定
  blog.default_extension = ".md"
end

helpers do
  def hostUrl link
    link
  end
end
```

※ hostUrl ヘルパーは後で使うフックとして用意しておきます。

次に source/index.html.slim を次のように記述します。(ERBを使う人は適宜読み替えてください)

```
---
title: (ブログタイトル)
---
h1 (ブログタイトル)

- blog.articles.each do |article|
  article
    h1
      = link_to article.title, hostUrl(article.url)
      time= article.date.strftime("%Y/%m/%d(#{%w(日 月 火 水 木 金 土)[article.date.wday]})")
    = article.summary
    = link_to 'もっと読む', hostUrl(article.url)
```

これで最低限の準備は終わりました！ あとは，source/yyyy-mm-dd-title.html.md というようなファイルを作って次のように書くとブログ記事を書きことができます。(yyyy は西暦年，mm は月，dd は日，title には英小文字のタイトルをつけます。ちなみにタイトルに大文字を混ぜるとハマりますので，使わないほうがいいです)

```md
---
title: タイトル
---
# タイトル

記事

```

### 4. GitHub Falavored Markdown の導入

Gemfile に下記を追加します。

```
gem 'redcarpet'
gem 'nokogiri'
```

下記のコマンドを実行します。

```
$ bundle install
```

config.rb に下記を追加します。

```
## GitHub Flavored Markdown
set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true
set :markdown_engine, :redcarpet
```

### 5. GitHub Pages にデプロイする

デプロイには middleman-deploy を利用します。Gemfile に下記を追加します。

```
gem 'middleman-deploy', '~> 2.0.0.pre.alpha'
```

その後，次のコマンドを実行します。

```
$ bundle install
```

config.rb に書いた hostUrl を次のように変更します。 

```
helpers do
  def hostUrl link
    'https://(ユーザー名).github.io/(リポジトリ名)' + link
  end
end
```

config.rb に下記の記述を追加します。

```
# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
  # リポジトリ名を host に設定しておく
  # こうすることで stylesheet_link_tag などで展開されるパスが
  # https://(ユーザー名).github.io/(リポジトリ名)/stylesheets/*.css
  # のようになる
  activate :asset_hash
  activate :asset_host, :host => 'https://(ユーザー名).github.io/(リポジトリ名)'
end

# デプロイの設定
# 今回は gh-pages を使用するので branch に 'gh-pages' を設定する
activate :deploy do |deploy|
  deploy.build_before = true
  deploy.deploy_method = :git
  deploy.branch = 'gh-pages'
end
```

以上の準備が終わったところで，次のコマンドを実行すると，GitHub Pages にデプロイされます。

デプロイしてから10分程度待った後に， https://(ユーザー名).github.io/(リポジトリ名) にアクセスするとサイトができています。

