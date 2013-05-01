class Api::V1::AreaIntroCatesController < Api::ApiController
  def index
    areas = AreaIntroCate.select("id, name")
    render :json => areas
  end
end
