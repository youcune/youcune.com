# changefreq Definition Hash
# { String | Regexp } file => { Symbol | String | nil } freq
changefreqs = {
  'index.html' => :weekly,
  'mono/index.html' => :daily,
  /^mono\/tags\// => :weekly,
  /^mono\/2014/ => :daily,
  /^mono\/20\d\d/ => :never,
  /^mono\/\w+\/[\w-]+\.html$/ => :never
}

# priority Definition Hash
# { String | Regexp } file => { Float | nil } priority
priorities = {
  'index.html' => 1.0,
  'mono/index.html' => 1.0,
  /^mono\/tags\// => 0.4,
  /^mono\/20\d\d/ => 0.4,
  /^mono\/\w+\/[\w-]+\.html$/ => 0.8
}

xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  sitemap.resources.each do |resource|
    xml.url do
      # loc
      xml.loc "http://youcune.com#{resource.url}"

      # lastmod
      lastmod = resource.data.modify_date.presence || resource.data.date.presence
      xml.lastmod lastmod if lastmod.present?

      # changefreq
      changefreqs.each do |file, freq|
        next if file.kind_of?(String) && resource.destination_path != file
        next if file.kind_of?(Regexp) && resource.destination_path !~ file
        xml.changefreq freq.to_s
        break
      end

      # priority
      priorities.each do |file, priority|
        next if file.kind_of?(String) && resource.destination_path != file
        next if file.kind_of?(Regexp) && resource.destination_path !~ file
        xml.priority priority.to_s
        break
      end
    end if resource.destination_path =~ /\.(html)$/
  end
end
