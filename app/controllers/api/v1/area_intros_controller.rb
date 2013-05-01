class Api::V1::AreaIntrosController < Api::ApiController
  def index
    area_id = params[:area_id]
    intros = AreaIntro.where("area_id = #{area_id}").select("id, title, area_intro_cate_id")
    render :json => intros
  end

  def show
    intro = AreaIntro.select("id,title, area_intro_cate_id,intro").find(params[:id])
    render :json => intro
  end
end
