xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  sitemap.resources.each do |resource|
    next if resource.destination_path !~ /\.html$/
    next if resource.destination_path =~ /^tags/
    next if resource.destination_path == "404.html"
    next if resource.destination_path =~ /^20\d\d\/index.html/
    xml.url do
      xml.loc "https://youcune.com#{resource.url}"
    end
  end
end
