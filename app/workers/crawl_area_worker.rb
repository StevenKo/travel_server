# encoding: utf-8
class CrawlAreaWorker
  include Sidekiq::Worker
  sidekiq_options queue: "travel"
  
  def perform(nation_id)
    nation= Nation.find(nation_id)
    c = TravelCrawler.new
    c.fetch nation.link.downcase
    c.crawl_nation_area nation.id
  end
end