class Api::V1::SitesController < Api::ApiController
  def index
    area_id = params[:area_id]
    sites = Site.where("area_id = #{area_id}").select("id, name, pic,rank").paginate(:page => params[:page], :per_page => 20).order("rank DESC")
    render :json => sites
  end

  def nation_group
    nation_group_id = params[:nation_group_id]
    sites = Site.where("nation_group_id = #{nation_group_id}").select("id, name, pic,rank").paginate(:page => params[:page], :per_page => 20).order("rank DESC")
    render :json => sites
  end

  def show
    site = Site.find(params[:id])
    render :json => site
  end

  def search
    sites = Site.search(params)
    if sites.present?
      ids = sites.map{|item| item["id"]}.join(",")
      @sites = Site.where("id in (#{ids})").select("id, name, pic,rank")
      render :json => @sites
    else
      render :json => []
    end

  end
end
