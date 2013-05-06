# encoding: utf-8
class CrawlNationIntroWorker
  include Sidekiq::Worker
  sidekiq_options queue: "travel"
  
  def perform(nation_Id)
    nation= Nation.find(nation_Id)
    c = TravelCrawler.new
    c.fetch nation.link.downcase.gsub("tourism", "travel")
    c.crawl_nation_intro nation.id
  end
end