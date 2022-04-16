require 'fastimage'

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
  def icon(style, name, text = nil, html_options = {})
    text, html_options = nil, text if text.is_a?(Hash)

    content_class = "#{style} fa-#{name}"
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
end

activate :directory_indexes

# Build-specific configuration
configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :minify_html
  activate :asset_hash
  activate :gzip
end

after_build do
  Dir.glob('build/images/**/*.*').each do |file|
    system("echo '#{file}: '; cwebp -short #{file} -o #{file}.webp")
  end
end

class YoucuneRenderer < Redcarpet::Render::HTML
  def image(link, title, alt_text)
    size = FastImage.size(File.join('source', 'images', link))
    "<img src=\"/images/#{link}\" alt=\"#{alt_text}\" width=\"#{size[0]}\" height=\"#{size[1]}\">"
  end
end

set :markdown_engine, :redcarpet
set :markdown, renderer: YoucuneRenderer

# 暫定対応
# @see https://github.com/middleman/middleman/issues/2113
Haml::TempleEngine.disable_option_validator!
