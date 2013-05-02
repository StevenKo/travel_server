class Site < ActiveRecord::Base
  attr_accessible :name, :pic, :info, :intro, :area_id, :rank,:nation_id, :nation_group_id
end
