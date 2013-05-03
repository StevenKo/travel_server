# encoding: utf-8
namespace :crawl do
  task :crawl_nations => :environment do
    states = State.all
    
    states.each_with_index do |state,i|
      next if (i == 8)
      c = TravelCrawler.new
      c.fetch state.link
      c.crawl_nations state.id
    end
  end

  task :crawl_areas => :environment do
    nations = Nation.all
    
    nations.each_with_index do |nation,i|
      CrawlAreaWorker.perform_async(nation.id)
    end
  end

  task :crawl_nation_group => :environment do
    c = TravelCrawler.new
    c.lvping_fetch "/"
    c.crawl_nation_group
  end

  task :crawl_area_detail => :environment do
    areas = Area.select("id").all

    areas.each do |area|
      CrawlAreaDetailWorker.perform_async(area.id)
    end
  end

  task :crawl_city_group => :environment do
    c = TravelCrawler.new
    c.lvping_fetch "/"
    c.crawl_city_group
  end

  ## 整理nation_group
  ##################################

  task :crawl_area_intro => :environment do
    areas = Area.select("id").all

    areas.each do |area|
      CrawlAreaIntroWorker.perform_async(area.id)
    end
  end

  task :crawl_area_site => :environment do
    areas = Area.select("id,link").all

    areas.each do |area|
      CrawlAreaSiteWorker.perform_async(area.id, area.link.downcase.gsub("tourism", "attractions"))
    end
  end


  task :crawl_area_notes => :environment do
    areas = Area.select("id,note_link").all

    areas.each do |area|
      CrawlAreaNoteWorker.perform_async(area.id,1,area.note_link)
    end
  end

  task :crawl_area_notes_order_new => :environment do
    areas = Area.select("id,note_link").all

    areas.each do |area|
      c = TravelCrawler.new
      c.fetch area.note_link
      CrawlNoteOrderNewWorker.perform_async(area.id,1,c.page_html.css(".tab_items_new a")[2][:href])
    end
  end

  task :crawl_best_notes => :environment do
    CrawlBestNoteWorker.perform_async(1,"/journals.aspx?type=3&dname=&title=&tag=0&tagn=&author=&group=0&orderby=")
  end

  task :crawl_new_notes => :environment do
    CrawlNewNoteWorker.perform_async(1,"/journals.aspx?type=0&dname=&title=&tag=0&tagn=&author=&group=0&orderby=")
  end

  task :crawl_most_view_notes => :environment do
    CrawlMostViewNoteWorker.perform_async(1,"/journals.aspx?type=0&dname=&title=&tag=0&tagn=&author=&group=0&orderby=r")
  end

end