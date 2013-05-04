class Area < ActiveRecord::Base
  has_many :area_note_relations
  has_many :notes, :through => :area_note_relations
end
