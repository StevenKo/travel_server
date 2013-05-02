# encoding: utf-8
class CrawlAreaNoteWorker
  include Sidekiq::Worker
  sidekiq_options queue: "travel"
  
  def perform(area_id,order,link)
    area= Area.find(area_id)
    c = TravelCrawler.new
    c.fetch link
    c.crawl_area_notes area.id,order
  end
end