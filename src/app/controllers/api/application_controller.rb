class Api::ApplicationController < ApplicationController
  def index
    status = { status: 'online' }
    render json: status
  end
end