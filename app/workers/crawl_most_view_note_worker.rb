# encoding: utf-8
class CrawlMostViewNoteWorker
  include Sidekiq::Worker
  sidekiq_options queue: "travel"
  
  def perform(order,link)
    c = TravelCrawler.new
    c.fetch link
    c.crawl_most_view_note order
  end
end