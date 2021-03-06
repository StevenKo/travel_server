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

  task :crawl_nation_hot_city => :environment do
    Nation.all.each do |n|
      c = TravelCrawler.new
      c.fetch n.link
      scripts = c.page_html.css("script")
      as = scripts.text.match(/var photoArray=(.*)showName:true/).to_s.split("photoViewerUrl:\"")
      as.each do |a|
        if a.index('",caption')
          link = a[0..a.index('",caption')-1]
          area = Area.find_by_link(link)
          unless area
             area = Area.new
             area.link = link
             area.nation_id = n.id
             area.save
          end
        end
      end
    end

    Area.where("name is null").each do |area|
      CrawlAreaDetailWorker.perform_async(area.id)
    end
  end

  task :delete_duplicate_area => :environment do
    Area.select("id,link").find_in_batches do |areas|
      areas.each do |area|
        all = Area.where("link = ?",area.link)
        if all.size > 1
          all.each_with_index do |a,index|
            next if index == 0
            a.delete
          end
        end
      end
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

  task :crawl_nation_intro => :environment do
    nations = Nation.select("id").all

    nations.each do |nation|
      CrawlNationIntroWorker.perform_async(nation.id)
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
      CrawlAreaNoteWorker.perform_async(area.id,1,area.note_link) if area.note_link
    end
  end

  task :crawl_area_notes_order_new => :environment do
    areas = Area.select("id,note_link").all

    areas.each do |area|
      if (area.note_link)
        CrawlNoteOrderNewWorker.perform_async(area.id,1,area.note_link.gsub("sh0","s0"))
      end
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

  task :creat_aboard_hot => :environment do
    (1..20).each do |page|
      notes = AreaNoteRelation.joins(:note).where("area_note_relations.nation_group_id in (15,16,17,19,20,25,26,27,28,29,30,31,32,33,34,35)").select("notes.id, notes.order_best").paginate(:page => page, :per_page => 20).order("order_best ASC")
      notes.each do |note|
        hot = AbordHotNotes.new
        hot.note_id = note.id
        hot.order = note.order_best
        hot.save
      end
    end
  end

end