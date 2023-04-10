class V1::InvitationsController < V1::ApplicationController
  before_action :set_item, only: %i[ show ]
  def index
    @items = Item.all
    render json: @items
  end
  def show
  end
  private
  def set_item
    @item = Item.find(params[:id])
  end
end