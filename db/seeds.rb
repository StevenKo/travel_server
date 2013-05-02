# encoding: UTF-8

s = State.new
s.name = "中國大陸"
s.name_cn = "中国"
s.link = "/tourism-d110000-china.html"
s.save

s = State.new
s.name = "亞洲"
s.name_cn = "亚洲"
s.link = "/tourism-d120001-asia.html"
s.save

s = State.new
s.name = "歐洲"
s.name_cn = "欧洲"
s.link = "/tourism-d120002-europe.html"
s.save

s = State.new
s.name = "大洋州"
s.name_cn = "大洋州"
s.link = "/tourism-d120003-oceania.html"
s.save

s = State.new
s.name = "非洲"
s.name_cn = "非洲"
s.link = "/tourism-d120006-africa.html"
s.save

s = State.new
s.name = "北美洲"
s.name_cn = "北美洲"
s.link = "/tourism-d120004-north_america.html"
s.save

s = State.new
s.name = "南美洲"
s.name_cn = "南美洲"
s.link = "/tourism-d120005-south_america.html"
s.save

s = State.new
s.name = "南极"
s.name_cn = "南极"
s.link = "/journals.aspx?type=3&group=42"
s.save

n = Nation.new
n.name = "南极"
n.name_cn = "南极"
n.link = "/journals.aspx?type=3&group=42"
n.state_id = 8
n.nation_group_id = 8
n.save


