class Api::V1::StatesController < Api::ApiController
  def index
    states = State.select("id, name, name_cn, link")
    render :json => states
  end
end
