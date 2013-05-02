class Api::V1::NationGroupsController < ApplicationController
  def index
    ngs = NationGroup.select("id,name,state_id")
    render :json => ngs
  end
end
