class CityGroup < ActiveRecord::Base
  has_many :citi_and_city_group_relations
  has_many :areas , :through => :citi_and_city_group_relations
end
