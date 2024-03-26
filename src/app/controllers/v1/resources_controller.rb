class V1::ResourcesController < V1::ApplicationController
  def index
    status = { status: 'ok' }
    render json: status
  end
end