class Note < ActiveRecord::Base

  include Tire::Model::Search
  include Tire::Model::Callbacks
  
  has_one :best_note
  has_one :new_note
  has_one :most_view_note

  has_many :area_note_relations
  has_many :areas, :through => :area_note_relations

  def self.search(params)
    tire.search(page: params[:page], per_page: 20) do
      query { string "title: #{params[:keyword]}", default_operator: "AND" }
    end
  end

  mapping do
    indexes :id, type: 'integer'
    indexes :title, :analyzer => "cjk"
  end

end
