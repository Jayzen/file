require 'open-uri'
require 'nokogiri'
16.times do |i|
  url = "https://www.driftingruby.com/episodes?page=#{i+1}"
  doc = Nokogiri::HTML(open(url))
  doc.css(".episode_title a").each do |paper|
    p paper.content
  end
end
