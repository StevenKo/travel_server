class Note < ActiveRecord::Base
  has_one :best_note
  has_one :new_note
  has_one :most_view_note
end
