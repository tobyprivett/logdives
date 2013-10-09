class CrawlDiveSites
  require "net/http"
  require "uri"

  class << self

    #
    # def grab
    #   DiveSite.where(:added_by_id => nil).delete_all
    #   require 'nokogiri'
    #
    #   file = "#{RAILS_ROOT}/db/dive_sites/divesitedirectory.com.html"
    #   p "Opening file: #{file}"
    #
    #   doc = Nokogiri::HTML.parse(File.open(file, "r"))
    #
    #   doc.css('li').each do | s |
    #
    #     source = s.css('a').first[:href]
    #     source = "http://divesitedirectory.com/#{source}" if source.present?
    #     t = s.text.split(" - ")
    #     site =  t.first
    #
    #     p site
    #
    #     if t && t[1].present?
    #       l = t[1].split(", ")
    #
    #       if l &&  l.first.present?
    #         if l.first.include?("(")
    #           location = l.first.split(" (").first
    #         else
    #           location = l.first.split(", ").first
    #         end
    #       end
    #
    #       DiveSite.create :site => site.strip, :location => location.strip, :source => source.strip
    #
    #     else
    #       p "issue with: #{site}"
    #     end
    #   end
    # end
    #
    # def scrape
    #   DiveSite.where(:latlong => nil).where('source is not null').each do |ds|
    #     begin
    #       p '----------'
    #       p ds.source
    #       doc = Nokogiri::HTML(open(ds.source))
    #       ret =  doc.css('p.padtop4').first.to_s.gsub("<p class=\"padtop4\">Location: ","").gsub("</p>","").strip
    #
    #       p ret
    #       ds.latlong_builder =  ret
    #
    #       ds.save if ds.latlong_builder_changed?
    #
    #     rescue => e
    #       p "ERROR: #{ds} #{e.message}"
    #
    #     end
    #   end
    # end



    def bing_images(search_for)
      uri = URI.parse("http://api.search.live.net/json.aspx?Appid=66CFFB547177B84037A660785F802634B0255628&Query=#{search_for}&Sources=image")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      results = ActiveSupport::JSON.decode(response.body)["SearchResponse"]["Image"]["Results"]
      return unless results
      ret = results.map do |i|
        {
          :title => i["Title"],
          :source => i["Url"],
          :thumb => i["Thumbnail"]["Url"]
        }
      end
    end

     def bing_weblinks(search_for)
        uri = URI.parse("http://api.search.live.net/json.aspx?Appid=66CFFB547177B84037A660785F802634B0255628&Query=#{search_for}&Sources=web")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        results = ActiveSupport::JSON.decode(response.body)["SearchResponse"]["Web"]["Results"]
        p results
        return unless results
        ret = results.map do |i|
          {
            :title => i["Title"],
            :source => i["Url"],
            :description => i["Description"]
          }
        end
      end

    def load_all
      DiveSite.all.each do |ds|
        p "Loading: #{ds}"
        ds.images_hash = CrawlDiveSites.bing_images(URI::escape('dive ' + ds.name))
        ds.weblinks_hash = CrawlDiveSites.bing_weblinks(URI::escape('dive ' + ds.name))
        ds.save if ds.images_hash_changed?
        sleep (0.2)
      end
    end
  end
end
