class Api::V1::SitesController < Api::ApiController
  def index
    area_id = params[:area_id]
    sites = Site.where("area_id = #{area_id}").select("id, name, pic,rank")
    render :json => sites
  end

  def show
    site = Site.find(params[:id])
    render :json => site
  end
end
