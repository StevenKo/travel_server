# encoding: utf-8
namespace :crawl do
  task :crawl_nations => :environment do
    states = State.all
    
    states.each do |state|
      c = TravelCrawler.new
      c.fetch state.link
      c.crawl_nations state.id
    end
  end

  task :crawl_areas => :environment do
    nations = Nation.all
    
    nations.each do |nation|
      c = TravelCrawler.new
      c.fetch nation.link.downcase
      c.crawl_nation_area nation.id
    end
  end

  task :crawl_area_detail => :environment do
    areas = Area.all

    areas.each do |area|
      c = TravelCrawler.new
      c.fetch area.link.downcase
      c.crawl_area_detail area.id
    end
  end

  task :crawl_area_intro => :environment do
    areas = Area.all

    areas.each do |area|
      c = TravelCrawler.new
      c.fetch area.link.downcase.gsub("tourism", "travel")
      c.crawl_area_intro area.id
    end
  end

  task :crawl_area_intro => :environment do
    areas = Area.all

    areas.each do |area|
      c = TravelCrawler.new
      c.fetch area.link.downcase.gsub("tourism", "attractions")
      c.crawl_area_sites area.id
    end
  end

  task :crawl_area_intro => :environment do
    areas = Area.all

    areas.each do |area|
      c = TravelCrawler.new
      c.fetch area.link.downcase.gsub("tourism", "attractions")
      c.crawl_area_sites area.id
    end
  end

  task :crawl_area_notes => :environment do
    areas = Area.all

    areas.each do |area|
      c = TravelCrawler.new
      c.fetch area.note_link
      c.crawl_area_notes area.id,1
    end
  end

  task :crawl_area_notes => :environment do
    areas.each do |area|
      c = TravelCrawler.new
      c.fetch area.note_link
      c.fetch c.page_html.css(".tab_items_new a")[2][:href]
      c.crawl_area_notes_order_new area.id,1
    end
  end

end