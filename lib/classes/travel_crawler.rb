# encoding: utf-8
class TravelCrawler
  include Crawler

  def crawl_nations state_id
    nodes = nil
    if state_id == 1
      nodes = @page_html.css("#Main_divMap a")
    else
      nodes = @page_html.css("#Main_divMap a.map_site_s2,#Main_divMap a.map_site_s3,#Main_divMap a.map_site_s4,#Main_divMap a.map_site_s5")
    end
    nodes.each do |node|
      nation = Nation.new
      nation.name = ZhConv.convert("zh-tw", node.text)
      nation.name_cn = node.text
      nation.link = node[:href]
      next if(nation.link == "/tourism-d110000-china.html")
      next if Nation.find_by_link(node[:href])
      nation.state_id = state_id
      nation.save
      puts node.text
    end
  end

  def crawl_nation_area nation_id
    
    raise "maybe link error" if @page_html.children.size == 1

    nodes = @page_html.css("map area")
    nodes.each do |node|
      if(node[:href].present?)
        a = Area.new
        next if Area.find_by_link(node[:href])
        a.link = node[:href]
        a.nation_id = nation_id
        a.save
      end
    end

    if nodes.blank?
      nation = Nation.find(nation_id)
      a = Area.new
      a.link = nation.link
      a.nation_id = nation_id
      a.save
    end
  end

  def crawl_area_detail area_id
    a = Area.find(area_id)
    pic = @page_html.css(".desContainer.cf .cf img.city-sign")[0][:src] unless @page_html.css(".desContainer.cf .cf img.city-sign").blank?
    note_link = @page_html.css("#Main_divJournals .link-all a")[0][:href] unless @page_html.css("#Main_divJournals .link-all a").blank?
    site_link = @page_html.css("#Main_divSightRank .link-all a")[0][:href] unless @page_html.css("#Main_divSightRank .link-all a").blank?
    raise "maybe link error" if @page_html.css(".main-title").blank?
    title = @page_html.css(".main-title").text.strip
    puts area_id
    a.pic = pic if pic 
    a.note_link = note_link if note_link
    a.site_link = site_link if site_link
    a.name_cn = title
    a.name = ZhConv.convert("zh-tw", @page_html.css(".main-title").text.strip)
    a.save

    area_nodes = @page_html.css("#Main_divNearbyCity a.fake-a")
    area_nodes.each do |a_node|
      a_node = a_node.next
      area = Area.find_by_link(a_node[:href])
      next if area
      area = Area.new
      area.link = a_node[:href]
      area.nation_id = a.nation_id
      area.save

      CrawlAreaDetailWorker.perform_async(area.id)
    end
  end

  def crawl_area_intro area_id
    nodes = @page_html.css(".wiki-list-title")
    nodes.each do |node|
      cat_title = ZhConv.convert("zh-tw", node.text.strip)
      category = AreaIntroCate.find_by_name(cat_title)
      category = AreaIntroCate.create(:name => cat_title) unless category

      intro_nodes = node.next.next.css(".handbook-wiki-infor-detail")
      intro_nodes.each do |intro|
         a = AreaIntro.new
         a.title = intro.css("a").text
         next if a.title.index("此分类创建攻略")
         a.title = ZhConv.convert("zh-tw", a.title)

         finds = AreaIntro.where("area_id = #{area_id} and title = ?",a.title)
         next unless finds.blank?

         a.area_intro_cate_id = category.id
         a.area_id = area_id

         c = TravelCrawler.new
         c.fetch intro.css("a")[0][:href]
         node = c.page_html.css(".handbook-wiki-detail-con")[0]
         node.css("#imgUrl").remove
         img_nodes = node.css("img")
        img_nodes.each do |img_node|
          if img_node.attr("width")
            img_node.set_attribute("width","100%")
            img_node.set_attribute("height","auto")
          end
        end
        a_nodes = node.css("a")
        a_nodes.each do |a_node|
          a_node.set_attribute("style","color: #f00")
          a_node.name = "span"
        end
         conver_nodo_tw(node)
         a.intro = node.to_html
         a.save
      end
    end
  end

  def crawl_nation_intro nation_id
    nodes = @page_html.css(".wiki-list-title")
    nodes.each do |node|
      cat_title = ZhConv.convert("zh-tw", node.text.strip)
      category = AreaIntroCate.find_by_name(cat_title)
      category = AreaIntroCate.create(:name => cat_title) unless category

      intro_nodes = node.next.next.css(".handbook-wiki-infor-detail")
      intro_nodes.each do |intro|
         a = NationIntro.new
         a.title = intro.css("a").text
         next if a.title.index("此分类创建攻略")
         a.title = ZhConv.convert("zh-tw", a.title)

         finds = NationIntro.where("nation_id = #{nation_id} and title = ?",a.title)
         next unless finds.blank?

         a.area_intro_cate_id = category.id
         a.nation_id = nation_id

         c = TravelCrawler.new
         c.fetch intro.css("a")[0][:href]
         node = c.page_html.css(".handbook-wiki-detail-con")[0]
         node.css("#imgUrl").remove
         img_nodes = node.css("img")
        img_nodes.each do |img_node|
          if img_node.attr("width")
            img_node.set_attribute("width","100%")
            img_node.set_attribute("height","auto")
          end
        end
        a_nodes = node.css("a")
        a_nodes.each do |a_node|
          a_node.set_attribute("style","color: #f00")
          a_node.name = "span"
        end
         conver_nodo_tw(node)
         a.intro = node.to_html
         a.save
      end
    end
  end

  def crawl_area_sites area_id
    nodes = @page_html.css("#Main_DistrictSightListPage1_div_SightList dl")
    nodes.each do |node|
      name = node.css("dt a").text.strip
      name = ZhConv.convert("zh-tw", name)

      pic = node.css(".pic img")[0][:src]

      star = nil
      star_node = node.css("span[property='v:average']")
      star = star_node[0][:content] if star_node.present?

      c1 = TravelCrawler.new
      c1.fetch node.css("dt a")[0][:href]
      nodes_items = c1.page_html.css("#Main_divSightDetail .item")
      nodes = c1.page_html.css("#Main_divSightDetail")
      info = nodes.to_html.gsub(nodes_items[0].to_html,"")
      if nodes_items.last.text.include? ("没有点评")
        info.gsub!(nodes_items.last.to_html,"")
      end
      info.gsub!("<a ","<span ")
      info.gsub!("</a>","</span>")
      doc = Nokogiri::HTML.parse(info)
      doc.css('text()').each do |info_text|
        info_text.content = ZhConv.convert("zh-tw", info_text.content)
      end
      info = doc.to_html

      intro = c1.page_html.css("#Main_divSightIntroduce")
      intro_texts = intro.css('#Main_divSightIntroduce text()')
      intro_texts.each do |intro_text|
        intro_text.content = ZhConv.convert("zh-tw", intro_text.content)
      end
      intro = c1.page_html.css("#Main_divSightIntroduce").to_html
      intro.gsub!("<a ","<span ")
      intro.gsub!("</a>","</span>")

      # pics
      scripts = c1.page_html.css("script")
      as = scripts.text.match(/smlImgSrc:(.*)photoViewerUrl/).to_s.split("lgrImgSrc:\"")
      pics = as.collect{|a| a[0..a.index('",photoViewerUrl')-1] if a.index('",photoViewerUrl')}
      pics.delete_if{|pic| pic.nil?}
      pics = pics.join(",")

      area = Area.select("id, nation_id").find(area_id)
      nation = Nation.select("id, nation_group_id").find(area.nation_id)
      
      sites = Site.where("area_id = #{area_id} and name = ?",name)
      if sites.blank?
        site = Site.create(:name => name, :pic => pic, :rank => star, :info => info, :intro => intro, :area_id => area_id, :nation_id => nation.id, :nation_group_id => nation.nation_group_id,:pics => pics)
      else
        site = sites[0].update_attributes(:name => name, :pic => pic, :rank => star, :info => info, :intro => intro, :area_id => area_id, :nation_id => nation.id, :nation_group_id => nation.nation_group_id,:pics => pics)
      end
    end

    link = @page_html.css(".desNavigation a").last
    if (link.present? && link.text.index(">>") != nil)
      CrawlAreaSiteWorker.perform_async(area_id,link[:href])
    end
  end


  def crawl_area_notes area_id, order
    nodes = @page_html.css(".forum-item")
    nodes.each do |node|
      parse_note(node,order,area_id)
    end

    a_node = @page_html.css(".new-paging em.current")[0]
    if a_node.next.name == "a"
      CrawlAreaNoteWorker.perform_async(area_id,order,a_node.next[:href])
    end

  end

  def crawl_area_notes_order_new area_id, order
    nodes = @page_html.css(".forum-item")
    nodes.each do |node|
      title = node.css("h3 a").text.strip
      note = Note.select("id").find_by_title(title)
      next unless note
      note.order_new = order
      order += 1
      note.save
    end
    a_node = @page_html.css(".new-paging em.current")[0]
    if a_node.next.name == "a"
      CrawlNoteOrderNewWorker.perform_async(area_id,order,a_node.next[:href])
    end
  end

  def crawl_nation_group

    ng = NationGroup.new
    ng.name_cn = "南极"
    ng.state_id = 8
    ng.save
    
    nodes = @page_html.css(".item-china em a")
    nodes.each do |node|
      ng = NationGroup.new
      ng.name_cn = node.text.strip
      ng.state_id = 1
      ng.save
    end

    nodes = @page_html.css(".item-asia em a")
    nodes.each do |node|
      ng = NationGroup.new
      ng.name_cn = node.text.strip
      ng.state_id = 2
      ng.save
    end

    nodes = @page_html.css(".item-europe em a")
    nodes.each do |node|
      ng = NationGroup.new
      ng.name_cn = node.text.strip
      ng.state_id = 3
      ng.save
    end

    ng = NationGroup.new
    ng.name_cn = "澳大利亚"
    ng.state_id = 4
    ng.save

    ng = NationGroup.new
    ng.name_cn = "新西兰及南太平洋岛国"
    ng.state_id = 4
    ng.save

    ng = NationGroup.new
    ng.name_cn = "美国、加拿大"
    ng.state_id = 6
    ng.save

    ng = NationGroup.new
    ng.name_cn = "墨西哥、古巴"
    ng.state_id = 7
    ng.save

    ng = NationGroup.new
    ng.name_cn = "巴西、阿根廷、秘鲁、智利"
    ng.state_id = 7
    ng.save
 
    ng = NationGroup.new
    ng.name_cn = "北非"
    ng.state_id = 5
    ng.save

    ng = NationGroup.new
    ng.name_cn = "南非"
    ng.state_id = 5
    ng.save

    ng = NationGroup.new
    ng.name_cn = "东非"
    ng.state_id = 5
    ng.save
    

    (1..7).each do |i|
      ng = NationGroup.new
      ng.name_cn = "其它"
      ng.state_id = i
      ng.save
    end

    NationGroup.all.each do |ng|
      ng.name = ZhConv.convert("zh-tw", ng.name_cn)
      ng.save
    end
    
    NationGroup.all.each do |ng|
      names = ng.name_cn.split("、")
      names.each do |name|
        nation = Nation.find_by_name_cn(name)
        next unless nation
        nation.nation_group_id = ng.id
        nation.save
      end
    end
  end

  def crawl_city_group
    nodes = @page_html.css(".item-season .panel-con ul li")
    nodes.each_with_index do |node,i|
      cg = CityGroup.new
      cg.name = ZhConv.convert("zh-tw", node.css("strong").text) 
      cg.group_id = 1
      cg.save

      area_nodes = node.css("a")
      area_nodes.each do |area_node|
        a = Area.find_by_name_cn(area_node.text.strip)
        puts area_node.text.strip unless a
        next unless a
        CitiAndCityGroupRelation.create(:area_id => a.id, :city_group_id => cg.id)
      end
    end

    nodes = @page_html.css(".item-theme .panel-con ul li")
    nodes.each_with_index do |node,i|
      cg = CityGroup.new
      cg.name = ZhConv.convert("zh-tw", node.css("strong").text) 
      cg.group_id = 2
      cg.save

      area_nodes = node.css("a")
      area_nodes.each do |area_node|
        a = Area.find_by_name_cn(area_node.text.strip)
        puts area_node.text.strip unless a
        next unless a
        CitiAndCityGroupRelation.create(:area_id => a.id, :city_group_id => cg.id)
      end
    end

    
    cg = CityGroup.new
    cg.name = ZhConv.convert("zh-tw", "最佳海边度假地") 
    cg.group_id = 3
    cg.save

    area_nodes = @page_html.css(".item-seaside .panel-con a")
    area_nodes.each do |area_node|
      a = Area.find_by_name_cn(area_node.text.strip)
      puts area_node.text.strip unless a
      next unless a
      CitiAndCityGroupRelation.create(:area_id => a.id, :city_group_id => cg.id)
    end
    
    c = TravelCrawler.new
    c.fetch "/journals/citys.aspx"

    cg = CityGroup.new
    cg.name = "中國和台灣"
    cg.group_id = 4
    cg.save

    area_nodes = c.page_html.css("#Main_div_hot_journal_inchina a")
    area_nodes.each do |area_node|
      a = Area.find_by_name_cn(area_node.text.strip)
      puts area_node.text.strip unless a
      next unless a
      CitiAndCityGroupRelation.create(:area_id => a.id, :city_group_id => cg.id)
    end

    cg = CityGroup.new
    cg.name = "國外城市"
    cg.group_id = 4
    cg.save

    area_nodes = c.page_html.css("#Main_div_hot_journal_abroad a")
    area_nodes.each do |area_node|
      a = Area.find_by_name_cn(area_node.text.strip)
      puts area_node.text.strip unless a
      next unless a
      CitiAndCityGroupRelation.create(:area_id => a.id, :city_group_id => cg.id)
    end



  end

  def change_node_br_to_newline node
    content = node.to_html
    content = content.gsub("<br>","\n")
    n = Nokogiri::HTML(content)
    n.text
  end

  def conver_nodo_tw node
    node.css('text()').each do |info_text|
      info_text.content = ZhConv.convert("zh-tw", info_text.content)
    end
  end

  def crawl_best_note order
    nodes = @page_html.css(".forum-item")
    nodes.each do |node|
      title = node.css("h3 a").text.strip
      note = Note.select("id").find_by_title(title)
      note = parse_note(node,nil) unless note
      best = BestNote.new
      best.note_id = note.id
      best.order = order
      order += 1
      best.save
    end

    a_node = @page_html.css(".new-paging em.current")[0]
    if a_node.next.name == "a"
      CrawlBestNoteWorker.perform_async(order,a_node.next[:href])
    end
  end


  def crawl_new_note order
    nodes = @page_html.css(".forum-item")
    nodes.each do |node|
      title = node.css("h3 a").text.strip
      note = Note.select("id").find_by_title(title)
      note = parse_note(node,nil) unless note
      best = NewNote.new
      best.note_id = note.id
      best.order = order
      order += 1
      best.save
    end

    a_node = @page_html.css(".new-paging em.current")[0]
    if a_node.next.name == "a"
      CrawlNewNoteWorker.perform_async(order,a_node.next[:href])
    end
  end

  def crawl_most_view_note order
    nodes = @page_html.css(".forum-item")
    nodes.each do |node|
      title = node.css("h3 a").text.strip
      note = Note.select("id").find_by_title(title)
      note = parse_note(node,nil) unless note
      best = MostViewNote.new
      best.note_id = note.id
      best.order = order
      order += 1
      best.save
    end

    a_node = @page_html.css(".new-paging em.current")[0]
    if a_node.next.name == "a"
      CrawlMostViewNoteWorker.perform_async(order,a_node.next[:href])
    end
  end

  def parse_note node,order,area_id=nil
    link = node.css("h3 a")[0][:href]
    title = node.css("h3 a").text.strip
    title = ZhConv.convert("zh-tw", title)
    
    note = Note.find_by_title(title)
    
    if (note == nil)
      read_num = node.css(".spt").text.match(/\d*/).to_s.to_i
      pic = nil
      pic = node.css(".item-photo img")[0][:src] unless node.css(".item-photo img").blank?
      author = node.css(".item-infor em a").text
      date = node.css(".item-infor i").text
      

      # change content html ###
      
      c1 = TravelCrawler.new
      c1.fetch node.css("h3 a")[0][:href]
      node = c1.page_html.css("#journal-content")[0]
      img_nodes = node.css("img")
      img_nodes.each do |img_node|
        img_node.set_attribute("width","100%")
        img_node.set_attribute("height","auto")
      end
      a_nodes = node.css("a")
      a_nodes.each do |a_node|
        a_node.set_attribute("style","color: #f00")
        a_node.name = "span"
      end
      conver_nodo_tw(node)
      content = node.to_html

      # end ###
      
      note = Note.new
      note.title = title
      note.author = author
      note.read_num = read_num
      note.date = date
      note.pic = pic
      note.content = content
      note.order_best = order
      note.link = link
      order += 1
      note.save
      
      if(area_id != nil)
        area = Area.select("id, nation_id").find(area_id)
        nation = Nation.select("id, nation_group_id").find(area.nation_id)
        relation = AreaNoteRelation.new
        relation.area_id = area_id
        relation.nation_id = area.nation_id
        relation.nation_group_id = nation.nation_group_id
        relation.note_id = note.id
        relation.save
      end

      return note
    else
      if(area_id != nil && AreaNoteRelation.where("note_id = #{note.id} and area_id = #{area_id}").blank?)
        area = Area.select("id, nation_id").find(area_id)
        nation = Nation.select("id, nation_group_id").find(area.nation_id)
        relation = AreaNoteRelation.new
        relation.area_id = area_id
        relation.nation_id = area.nation_id
        relation.nation_group_id = nation.nation_group_id
        relation.note_id = note.id
        relation.save
      end
      return note if note
    end
  end
end
