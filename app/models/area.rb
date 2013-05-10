class Area < ActiveRecord::Base
  has_many :area_note_relations
  has_many :notes, :through => :area_note_relations

  has_many :citi_and_city_group_relations
  has_many :city_groups , :through => :citi_and_city_group_relations

  belongs_to :nation
end
