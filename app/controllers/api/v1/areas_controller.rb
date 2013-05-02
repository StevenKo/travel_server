class Api::V1::AreasController < ApplicationController
  def index
    nation_id = params[:nation_id]
    areas = Area.where("nation_id = #{nation_id}").select("id, name, name_cn,pic")
    render :json => areas
  end

  def group_areas
    city_group_id = params[:city_group_id]
    areas = Area.where("city_group_id = #{city_group_id}").select("id, name, name_cn,pic")
    render :json => areas
  end
end
