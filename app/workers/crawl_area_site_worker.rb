# encoding: utf-8
class CrawlAreaSiteWorker
  include Sidekiq::Worker
  sidekiq_options queue: "travel"
  
  def perform(area_id,link)
    area= Area.find(area_id)
    c = TravelCrawler.new
    c.fetch link
    c.crawl_area_sites area.id
  end
end