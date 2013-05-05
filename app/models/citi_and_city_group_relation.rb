class CitiAndCityGroupRelation < ActiveRecord::Base
  attr_accessible :area_id, :city_group_id
  belongs_to :area
  belongs_to :city_group
end
