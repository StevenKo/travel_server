class Api::V1::AreasController < ApplicationController
  def index
    nation_id = params[:nation_id]
    areas = Area.where("nation_id = #{nation_id}").select("id, name, name_cn")
    render :json => areas
  end
end
