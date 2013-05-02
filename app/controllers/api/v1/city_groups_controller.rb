class Api::V1::CityGroupsController < ApplicationController
  def index
    cgs = CityGroup.select("id,name,group_id")
    render :json => cgs
  end
end
