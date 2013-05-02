# encoding: utf-8
class CrawlAreaIntroWorker
  include Sidekiq::Worker
  sidekiq_options queue: "travel"
  
  def perform(area_id)
    area= Area.find(area_id)
    c = TravelCrawler.new
    c.fetch area.link.downcase.gsub("tourism", "travel")
    c.crawl_area_intro area.id
  end
end