class Api::V1::StatesController < Api::ApiController
  def index
    states = State.select("id, name, name_cn")
    render :json => states
  end
end
