###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page '/path/to/file.html', :layout => false
#
# With alternative layout
# page '/path/to/file.html', :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page '/admin/*'
# end

# Proxy (fake) files
# page '/this-page-has-no-template.html', :proxy => '/template-file.html' do
#   @which_fake_page = 'Rendering a fake page with a variable'
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     'Helping'
#   end
# end

helpers do
  def icon(icon, text="", html_options={})
    content_class = "fa fa-#{icon}"
    content_class << " #{html_options[:class]}" if html_options.key?(:class)
    html_options[:class] = content_class

    html = content_tag(:i, nil, html_options)
    html << " #{text}" unless text.blank?
    html.html_safe
  end

  # get Qiita Popular Posts
  def qiita_posts(post_count = 5)
    str = ''
    JSON.parse(Net::HTTP.get(URI.parse('https://qiita.com/api/v1/users/youcune/items?per_page=100')))
      .sort { |a, b| b['stock_count'] <=> a['stock_count'] }
      .first(post_count)
      .each do |a|
        str += "<li><a href=\"#{a['url']}?utm_source=portal&amp;utm_medium=portal&amp;utm_content=card\">#{a['title']} (#{a['stock_count']})</a></li>"
      end
    str.html_safe
  end

  # returns image url
  def image_url(source)
    "http://youcune.com#{image_path(source)}"
  end
end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

# Build-specific configuration
configure :build do
  require 'uglifier'

  activate :minify_html do |html|
    html.remove_http_protocol  = false
    html.remove_https_protocol = false
  end
  activate :minify_css
  activate :minify_javascript, compressor: Uglifier.new(comments: :none)

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require 'middleman-smusher'
  # activate :smusher
end
