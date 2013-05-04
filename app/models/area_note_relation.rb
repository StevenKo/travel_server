class AreaNoteRelation < ActiveRecord::Base
  belongs_to :area
  belongs_to :note
end
