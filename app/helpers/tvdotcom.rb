require 'hpricot'
require 'open-uri'

module Tvdotcom
  
  class Tvdotcom
    def initialize
    
    end
    
    def episodes forceUpdate=false
      #listingsUrl = "http://localhost/eclipse/scratch/tvdotcom/episode_listings.html"
      listingsUrl = "http://www.tv.com/the-colbert-report/show/45593/episode_listings.html?season=0&tag=nav_bar;all"
      if !forceUpdate && @episodes
        return @episodes
      end
        @episodes = Array.new
        doc = Hpricot open(listingsUrl, "Cache-Control" => "no-cache",  "Pragma" => "no-cache")
        # change the CSS class on links
        table = doc.at("div#episode-listing div.table-styled table")
        for row in table/:tr
          cols =  row/:td
          if cols.length == 7
            episode = Episode.new
            episode.number = cols[0].innerHTML.strip;
            episode.title = (cols[1]/:a).innerHTML.strip;
            episode.summary_href = (cols[1]/:a).first.attributes["href"];
            episode.air_date = cols[2].innerHTML.strip;
            @episodes << episode
          end #if
        end #for
        return @episodes
    end #epdisodes
    
    class Episode
      attr_accessor :air_date, :number, :title, :summary_href, :summary, :summary_html
      def initialize
        
      end
      
      def summary forceUpdate=false
        if forceUpdate ||  @summary.nil?
            get_summary()
        end
        return @summary
      end
      
      def summary_html forceUpdate=false
        if forceUpdate || @summary_html.nil?
            get_summary()
        end
        return @summary_html
      end
      
      def to_s
        return "Episode: #{@number} #{@title} #{@air_date}"  
      end
      
      def to_hash
           return {
              :air_date => @air_date,
              :number => @number,
              :title => @title,
              :summary_href => @summary_href,
              :summary => @summary,
              :summary_html => @summary_html
           }
      
      end
      
      private
      def get_summary
        #@summaryHref = "http://localhost/eclipse/scratch/tvdotcom/summary.html"
        doc = Hpricot(open(@summary_href))
        summaryElement = (doc/"div#main-col div").first
        @summary_html = summaryElement.inner_html.sub(%r{<div.*/div>}m, "").strip
        @summary = summaryElement.inner_text.sub("Read episode recap &raquo;", "").strip
      end
    end
    
  end
end