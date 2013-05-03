# encoding: utf-8
class CrawlNewNoteWorker
  include Sidekiq::Worker
  sidekiq_options queue: "travel"
  
  def perform(order,link)
    c = TravelCrawler.new
    c.fetch link
    c.crawl_new_note order
  end
end