###
# Blog settings
###

Time.zone = 'Tokyo'

page '/sitemap.xml', :layout => false

activate :blog do |blog|
  blog.prefix = 'mono'
  blog.permalink = ':category/:slug.html'
  blog.sources = ':category/:yyyymmdd_:slug.html'
  # blog.taglink = 'tags/:tag.html'
  blog.layout = 'mono-article'
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = ':year.html'
  # blog.month_link = ':year/:month.html'
  # blog.day_link = ':year/:month/:day.html'
  blog.default_extension = '.md'

  blog.tag_template = 'mono/tag.html'
  blog.calendar_template = 'mono/calendar.html'

  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = 'page/:num'
end

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
  def format_date(date)
    date.strftime('%Y.%m.%d')
  end

  def blog_title(title)
    if title.kind_of?(String) && title.present?
      "#{title} | Monolog"
    else
      'Monolog - @youcuneのブログ'
    end
  end

  def blog_meta_description(description)
    if description.kind_of?(String) && description.present?
      "<meta name=\"description\" content=\"#{description}\">"
    else
      ''
    end
  end

  def blog_tag_links(tags)
    tags.map { |tag| link_to(tag, tag_path(tag)) }.join(' ')
  end

  def xml_date(date)
    date.strftime('%Y-%m-%d')
  end

  # check if source matches target
  # @param [String] source
  # @param [String | Regexp] target
  def match?(source, target)
    return source == target if target.kind_of?(String)
    return !(source =~ target).nil? if target.kind_of?(Regexp)
    return false
  end
end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

set :markdown_engine, :rdiscount

# Build-specific configuration
configure :build do
  activate :minify_css
  activate :minify_javascript
  
  # Enable cache buster
  # activate :cache_buster
  
  # Use relative URLs
  # activate :relative_assets
  
  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require 'middleman-smusher'
  # activate :smusher
end

activate :deploy do |deploy|
  deploy.method = :sftp
  deploy.host   = 'louvre'
  deploy.path   = '/web/youcune.com'
end
