class Note < ActiveRecord::Base
  has_one :best_note
  has_one :new_note
  has_one :most_view_note

  has_many :area_note_relations
  has_many :areas, :through => :area_note_relations
end
