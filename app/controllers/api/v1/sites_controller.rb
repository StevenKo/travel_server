class Api::V1::SitesController < Api::ApiController
  def index
    area_id = params[:area_id]
    sites = Site.where("area_id = #{area_id}").select("id, name, pic,rank").order("rank ASC").paginate(:page => params[:page], :per_page => 20).order("rank ASC")
    render :json => sites
  end

  def nation_group
    nation_group_id = params[:nation_group_id]
    sites = Site.where("nation_group_id = #{nation_group_id}").select("id, name, pic,rank").paginate(:page => params[:page], :per_page => 20).order("rank ASC")
    render :json => sites
  end

  def show
    site = Site.find(params[:id])
    render :json => site
  end
end
