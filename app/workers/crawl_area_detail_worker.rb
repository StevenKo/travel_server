# encoding: utf-8
class CrawlAreaDetailWorker
  include Sidekiq::Worker
  sidekiq_options queue: "travel"
  
  def perform(area_id)
    area= Area.find(area_id)
    c = TravelCrawler.new
    c.fetch area.link.downcase
    c.crawl_area_detail area.id
  end
end