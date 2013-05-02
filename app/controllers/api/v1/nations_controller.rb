class Api::V1::NationsController < Api::ApiController
  
  def index
    nations = Nation.select("id, name, name_cn, state_id, nation_group_id")
    render :json => nations
  end
end
