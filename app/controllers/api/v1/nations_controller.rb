class Api::V1::NationsController < Api::ApiController
  
  def index
    state_id = params[:state_id]
    nations = Nation.where("state_id = #{state_id}").select("id, name, name_cn")
    render :json => nations
  end
end
