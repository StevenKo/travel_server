# encoding: utf-8
class TravelCrawler
  include Crawler

  def crawl_nations state_id
    nodes = @page_html.css("#Main_divMap a.map_site_s2,#Main_divMap a.map_site_s3,#Main_divMap a.map_site_s4")
    nodes.each do |node|
      nation = Nation.new
      nation.name = ZhConv.convert("zh-tw", node.text)
      nation.name_cn = node.text
      nation.link = node[:href]
      next if(nation.link == "/tourism-d110000-china.html")
      nation.state_id = state_id
      nation.save
      puts node.text
    end
  end

  def crawl_nation_area nation_id
    nodes = @page_html.css("map area")
    nodes.each do |node|
      if(node[:href].present?)
        a = Area.new
        a.link = node[:href]
        a.nation_id = nation_id
        a.save
      end
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
    a.name = ZhConv.convert("zh-tw", title)
    a.name_cn = title
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

      site = Site.create(:name => name, :pic => pic, :rank => rank, :info => info, :intro => intro, :area_id => area_id)
    end

    link = @page_html.css(".desNavigation a").last
    if link.text.index(">>") != nil
      c = TravelCrawler.new
      c.fetch link[:href]
      c.crawl_area_sites area_id
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

      note = Note.new
      note.title = title
      note.author = author
      note.read_num = read_num
      note.date = date
      note.pic = pic
      note.content = content
      note.area_id = area_id
      note.order_best = order
      note.link = link
      order += 1
      note.save
      puts @page_url

    end

    a_node = @page_html.css(".new-paging em.current")[0]
    if a_node.next.name == "a"
      c1 = TravelCrawler.new
      c1.fetch a_node.next[:href]
      c1.crawl_area_notes area_id,order
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
      c1 = TravelCrawler.new
      c1.fetch a_node.next[:href]
      c1.crawl_area_notes_order_new area_id,order
    end
  end

  def change_node_br_to_newline node
    content = node.to_html
    content = content.gsub("<br>","\n")
    n = Nokogiri::HTML(content)
    n.text
  end
end
