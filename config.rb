require 'fastimage'
require 'base64'

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
page 'articles/20*', layout: :article

# Cloudflare の not_found_handling: 404-page が /404.html を返す
page '/404.html', directory_index: false

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  blog.sources = "articles/{year}/{month}{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  blog.layout = "layouts/layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  blog.summary_generator = -> (article, body, length, ellipse) {
    body.gsub(/<[^>]+>/, '').gsub(/\s+/m, ' ').tap do |summary|
      break "#{summary.slice(0, length)} #{ellipse}" if summary.length > length
    end
  }
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  blog.default_extension = ".md"

  blog.tag_template = "tag.html"
  blog.year_template = "calendar.html"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
helpers do
  def icon(name, text = nil, html_options = {})
    text, html_options = nil, text if text.is_a?(Hash)

    content_class = "fa-#{name}"
    content_class << " #{html_options[:class]}" if html_options.key?(:class)
    html_options[:class] = content_class

    html = content_tag(:i, nil, html_options)
    html << ' ' << text.to_s unless text.blank?
    html
  end

  def amazon_link_tag(label, asin, *args)
    link_to(label, "https://www.amazon.co.jp/dp/#{asin}?tag=youcune-22", *args)
  end

  def image_tag_with_size(source, options)
    size = FastImage.size(File.join('source', 'images', source))

    if size.present?
      options.merge!(width: size[0], height: size[1])
    end

    image_tag(source, options)
  end

  # @param [String] path 'assets/stylesheets/all.scss.erb' のようなパス
  # @return [String] CSSの文字列
  def inline_scss(path)
    erb = ERB.new(File.read(File.join(root, path))).result(binding)
    css = SassC::Engine.new(erb, syntax: :scss, style: :compressed).render
    css.sub(/\A\uFEFF/, '') # BOM除去
  end

  def svg_data_url(style, name)
    path = File.join(root, 'assets', 'fontawesome', style, "#{name}.svg")
    svg  = File.read(path)
    # CSS内で扱いやすいよう軽く整形
    svg = svg.gsub(/<!--.*?-->/, '').gsub(/\s+/, ' ').gsub('"', "'").strip
    %Q{url("data:image/svg+xml;utf8,#{svg}")}
  end
end

activate :directory_indexes

# Build-specific configuration
configure :build do
  activate :minify_css
  activate :minify_html
  activate :asset_hash
end

# 縮小表示される画像向けに作る縮小版の幅
RESPONSIVE_WIDTH = 400
# ImageMagick 7 は magick、6（Ubuntu の apt 版）は convert
IMAGEMAGICK = system('command -v magick > /dev/null') ? 'magick' : 'convert'

# foo-abc123.jpg → foo-abc123-400w.jpg
def responsive_variant_path(path)
  path.sub(/(\.(?:jpe?g|png))\z/i, "-#{RESPONSIVE_WIDTH}w\\1")
end

# asset_hash でファイル名が確定した後の HTML に srcset / sizes を付ける
def add_srcset(html)
  html.gsub(/<img\b[^>]*>/) do |tag|
    src = tag[/\ssrc="?(\/images\/[^"\s>]+\.(?:jpe?g|png))/i, 1]
    next tag if src.nil? || tag.include?('srcset')

    variant = responsive_variant_path(src)
    next tag unless File.exist?(File.join('build', variant))

    width, = FastImage.size(File.join('build', src))
    # カードは3段組みで最大 400px 程度、記事中の画像は最大 800px
    sizes = tag.include?('card-img-top') ? '(min-width: 1200px) 400px, (min-width: 800px) 33vw, 100vw' : '(min-width: 800px) 800px, 100vw'
    tag.sub(/\s*\/?>\z/, %( srcset="#{variant} #{RESPONSIVE_WIDTH}w, #{src} #{width}w" sizes="#{sizes}">))
  end
end

after_build do
  FileUtils.cp('_redirects', 'build/_redirects')

  Dir.glob('build/images/**/*.{jpg,png}').each do |file|
    width, = FastImage.size(file)
    next unless width && width > RESPONSIVE_WIDTH

    variant = responsive_variant_path(file)
    system(IMAGEMAGICK, file, '-resize', "#{RESPONSIVE_WIDTH}x", variant)
    # パレット形式の PNG はフルカラーで書き出されて元より大きくなるので、256色で作り直す
    if file.end_with?('.png') && File.size(variant) >= File.size(file)
      system(IMAGEMAGICK, file, '-resize', "#{RESPONSIVE_WIDTH}x", '-colors', '256', "PNG8:#{variant}")
    end
    # それでも小さくならなければ縮小版は使わない（srcset も付かない）
    File.delete(variant) if File.size(variant) >= File.size(file)
  end

  Dir.glob('build/images/**/*.{jpg,png}').each do |file|
    system("echo '#{file}: '; cwebp -short #{file} -o #{file}.webp")
  end

  Dir.glob('build/**/*.html').each do |file|
    html = File.read(file)
    rewritten = add_srcset(html)
    File.write(file, rewritten) unless rewritten == html
  end
end

class YoucuneRenderer < Redcarpet::Render::HTML
  def image(link, title, alt_text)
    size = FastImage.size(File.join('source', 'images', link))
    "<img src=\"/images/#{link}\" alt=\"#{alt_text}\" width=\"#{size[0]}\" height=\"#{size[1]}\">"
  end
end

set :markdown_engine, :redcarpet
set :markdown, renderer: YoucuneRenderer, tables: true, fenced_code_blocks: true
