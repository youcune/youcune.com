# changefreq Definition Hash
# { String | Regexp } file => { Symbol | String | nil } freq
changefreqs = {
  'index.html' => :weekly,
  'mono/index.html' => :daily,
  /^mono\// => :weekly
}

# priority Definition Hash
# { String | Regexp } file => { Float | nil } priority
priorities = {
  'index.html' => 1.0,
  'mono/index.html' => 1.0,
  /^mono\/tags\// => 0.5,
  /^mono\/20\d\d/ => 0.1,
  /^mono\/\w+\/[\w-]+\.html$/ => 1.0
}

xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  sitemap.resources.each do |resource|
    xml.url do
      # loc
      xml.loc "https://youcune.com#{resource.url}"

      # lastmod
      lastmod = resource.data.modify_date.presence || resource.data.date.presence
      xml.lastmod lastmod if lastmod.present?

      # changefreq
      changefreqs.each do |file, freq|
        next unless match?(resource.destination_path, file)
        xml.changefreq freq.to_s if freq.present?
        break
      end

      # priority
      priorities.each do |file, priority|
        next unless match?(resource.destination_path, file)
        xml.priority priority.to_s if priority.present?
        break
      end
    end if resource.destination_path =~ /\.(html)$/
  end
end
