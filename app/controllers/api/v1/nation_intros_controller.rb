class Api::V1::NationIntrosController < ApplicationController
  def index
    nation_id = params[:nation_id]
    intros = NationIntro.where("nation_id = #{nation_id}").select("id, title, area_intro_cate_id")
    render :json => intros
  end

  def show
    intro = NationIntro.select("id,title, area_intro_cate_id,intro").find(params[:id])
    render :json => intro
  end
end
