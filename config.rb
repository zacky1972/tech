require 'slim'

$site_url = ''

set :time_zone, 'Tokyo'

activate :livereload

activate :relative_assets


activate :blog do |blog|
  # ブログ機能のオプションを設定
  blog.default_extension = ".md"
end

activate :external_pipeline, {
  name: :gulp,
  command: build? ? "gulp build" : 'gulp watch',
  source: "./build",
  latency: 1
}

## GitHub Flavored Markdown
set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true
set :markdown_engine, :redcarpet

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page '/path/to/file.html', layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy '/this-page-has-no-template.html', '/template-file.html', locals: {
#  which_fake_page: 'Rendering a fake page with a local variable' }

###
# Helpers
###

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
helpers do
  def hostUrl link
    $site_url + link
  end
end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript


  # activate :asset_hash

  # リポジトリ名を host に設定しておく
  # こうすることで stylesheet_link_tag などで展開されるパスが
  # https://zacky1972.github.io/tech/stylesheets/*.css
  # のようになる

  $site_url = 'https://zacky1972.github.io/tech'

  activate :asset_host, :host => $site_url

  activate :iepab, {
    name: :gulpPost,
    command: "gulp post",
    source: "./build",
    latency: 1
  }

end

# デプロイの設定
# 今回は gh-pages を使用するので branch に 'gh-pages' を設定する
activate :deploy do |deploy|
  deploy.build_before = true
  deploy.deploy_method = :git
  deploy.branch = 'gh-pages'
end