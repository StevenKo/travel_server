class Site < ActiveRecord::Base
  attr_accessible :name, :pic, :info, :intro, :area_id, :rank,:nation_id, :nation_group_id, :pics

  include Tire::Model::Search
  include Tire::Model::Callbacks

  def self.search(params)
    tire.search(page: params[:page], per_page: 20) do
      query { string "name: #{params[:keyword]}~", default_operator: "AND" }
    end
  end

  mapping do
    indexes :id, type: 'integer'
    indexes :name, :analyzer => "cjk"
  end
end
