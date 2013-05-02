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
    pic = @page_html.css(".desContainer.cf .cf img.city-sign")[0][:src]
    note_link = @page_html.css("#Main_divJournals .link-all a")[0][:href]
    site_link = @page_html.css("#Main_divSightRank .link-all a")[0][:href]
    title = @page_html.css(".main-title").text.strip
    puts area_id
    a.pic = pic
    a.note_link = note_link
    a.site_link = site_link
    a.name_cn = title
    a.name = ZhConv.convert("zh-tw", @page_html.css(".main-title").text.strip)
    a.save
  end

  def crawl_area_intro area_id
    nodes = @page_html.css(".wiki-list-title")
    nodes.each do |node|
      category = AreaIntroCate.find_by_name(node.text.strip)
      category = AreaIntroCate.create(:name => node.text.strip) unless category

      intro_nodes = node.next.next.css(".handbook-wiki-infor-detail")
      intro_nodes.each do |intro|
         a = AreaIntro.new
         a.title = intro.css("a").text
         next if a.title.index("此分类创建攻略")

         finds = AreaIntro.where("area_id = #{area_id} and title = ?",a.title)
         next unless finds.blank?

         a.area_intro_cate_id = category.id
         a.area_id = area_id

         c = TravelCrawler.new
         c.fetch intro.css("a")[0][:href]
         node = c.page_html.css(".handbook-wiki-detail-con")
         node.css("#imgUrl").remove
         a.intro = node.to_html
         a.save
      end
    end
  end

  def crawl_area_sites area_id
    nodes = @page_html.css("#Main_DistrictSightListPage1_div_SightList dl")
    nodes.each do |node|
      name = node.css("dt a").text.strip
      pic = node.css(".pic img")[0][:src]
      /第(.)名/ =~ node.css(".total_view_order").text
      rank = nil
      rank = $1.to_i unless $1 == nil

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

      intro = c1.page_html.css("#Main_divSightIntroduce").to_html

      area = Area.select("id, nation_id").find(area_id)
      nation = Nation.select("id, nation_group_id").find(area.nation_id)

      site = Site.create(:name => name, :pic => pic, :rank => rank, :info => info, :intro => intro, :area_id => area_id, :nation_id => nation.id, :nation_group_id => nation.nation_group_id)
    end

    link = @page_html.css(".desNavigation a").last
    if (link.present? && link.text.index(">>") != nil)
      CrawlAreaSiteWorker.perform_async(area_id,link[:href])
    end
  end


  def crawl_area_notes area_id, order
    nodes = @page_html.css("#Main_forumDetail .forum-item")
    nodes.each do |node|
      read_num = node.css(".spt").text.match(/\d*/).to_s.to_i
      pic = nil
      pic = node.css(".item-photo img")[0][:src] unless node.css(".item-photo img").blank?
      title = node.css("h3 a").text.strip
      link = node.css("h3 a")[0][:href]
      author = node.css(".item-infor em a").text
      date = node.css(".item-infor i").text
      
      c1 = TravelCrawler.new
      c1.fetch node.css("h3 a")[0][:href]
      content = c1.page_html.css("#journal-content").to_html
      
      area = Area.select("id, nation_id").find(area_id)
      nation = Nation.select("id, nation_group_id").find(area.nation_id)

      note = Note.new
      note.title = title
      note.author = author
      note.read_num = read_num
      note.date = date
      note.pic = pic
      note.content = content
      note.area_id = area_id
      note.order_best = order
      note.nation_id = area.nation_id
      note.nation_group_id = nation.nation_group_id
      note.link = link
      order += 1
      note.save

    end

    a_node = @page_html.css(".new-paging em.current")[0]
    if a_node.next.name == "a"
      CrawlAreaNoteWorker.perform_async(area_id,order,a_node.next[:href])
    end

  end

  def crawl_area_notes_order_new area_id, order
    nodes = @page_html.css("#Main_forumDetail .forum-item")
    nodes.each do |node|
      link = node.css("h3 a")[0][:href]
      note = Note.find_by_link(link)
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
    ng.name = "南极"
    ng.state_id = 8
    ng.save
    
    nodes = @page_html.css(".item-china em a")
    nodes.each do |node|
      ng = NationGroup.new
      ng.name = node.text.strip
      ng.state_id = 1
      ng.save
    end

    nodes = @page_html.css(".item-asia em a")
    nodes.each do |node|
      ng = NationGroup.new
      ng.name = node.text.strip
      ng.state_id = 2
      ng.save
    end

    nodes = @page_html.css(".item-europe em a")
    nodes.each do |node|
      ng = NationGroup.new
      ng.name = node.text.strip
      ng.state_id = 3
      ng.save
    end

    ng = NationGroup.new
    ng.name = "澳大利亚"
    ng.state_id = 4
    ng.save

    ng = NationGroup.new
    ng.name = "新西兰及南太平洋岛国"
    ng.state_id = 4
    ng.save

    ng = NationGroup.new
    ng.name = "美国、加拿大"
    ng.state_id = 6
    ng.save

    ng = NationGroup.new
    ng.name = "墨西哥、古巴"
    ng.state_id = 7
    ng.save

    ng = NationGroup.new
    ng.name = "巴西、阿根廷、秘鲁、智利"
    ng.state_id = 7
    ng.save
 
    ng = NationGroup.new
    ng.name = "北非"
    ng.state_id = 5
    ng.save

    ng = NationGroup.new
    ng.name = "南非"
    ng.state_id = 5
    ng.save

    ng = NationGroup.new
    ng.name = "东非"
    ng.state_id = 5
    ng.save
    

    (1..7).each do |i|
      ng = NationGroup.new
      ng.name = "其它"
      ng.state_id = i
      ng.save
    end
    
    NationGroup.all.each do |ng|
      names = ng.name.split("、")
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
      cg.name = node.css("strong").text
      cg.group_id = 1
      cg.save

      area_nodes = node.css("a")
      area_nodes.each do |area_node|
        a = Area.find_by_name_cn(area_node.text.strip)
        puts area_node.text.strip unless a
        next unless a
        a.city_group_id = cg.id
        a.save
      end
    end

    nodes = @page_html.css(".item-theme .panel-con ul li")
    nodes.each_with_index do |node,i|
      cg = CityGroup.new
      cg.name = node.css("strong").text
      cg.group_id = 2
      cg.save

      area_nodes = node.css("a")
      area_nodes.each do |area_node|
        a = Area.find_by_name_cn(area_node.text.strip)
        puts area_node.text.strip unless a
        next unless a
        a.city_group_id = cg.id
        a.save
      end
    end

    
    cg = CityGroup.new
    cg.name = "最佳海边度假地"
    cg.group_id = 3
    cg.save

    area_nodes = @page_html.css(".item-seaside .panel-con a")
    area_nodes.each do |area_node|
      a = Area.find_by_name_cn(area_node.text.strip)
      puts area_node.text.strip unless a
      next unless a
      a.city_group_id = cg.id
      a.save
    end
    

  end

  def change_node_br_to_newline node
    content = node.to_html
    content = content.gsub("<br>","\n")
    n = Nokogiri::HTML(content)
    n.text
  end
end
