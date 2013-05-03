# encoding: utf-8
class CrawlBestNoteWorker
  include Sidekiq::Worker
  sidekiq_options queue: "travel"
  
  def perform(order,link)
    c = TravelCrawler.new
    c.fetch link
    c.crawl_best_note order
  end
end