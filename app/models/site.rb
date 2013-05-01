class Site < ActiveRecord::Base
  attr_accessible :name, :pic, :order, :info, :intro, :area_id
end
