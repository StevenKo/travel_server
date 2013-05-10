class Nation < ActiveRecord::Base
  belongs_to :state
  has_many :areas
end
