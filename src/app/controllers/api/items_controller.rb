class Api::ItemsController < Api::ApplicationController
  before_action :api_logged_in_account, only: %i[ create ]
  before_action :set_item, only: %i[ show ]
  def index
    @items = Item.all
    #render json: @items
  end
  def show
    render 'items/show'
  end
  def create
    @item = Item.new(
      content: params[:content],
      nsfw: params[:nsfw],
      cw: params[:cw]
    )
    @item.account_id = @current_account.id
    @item.item_id = unique_random_id(Item, 'item_id')
    @item.uuid = SecureRandom.uuid
    @item.item_type = 'plane'
    if @item.save
      item = create_item_broadcast_format(@item)
      ActionCable.server.broadcast 'items_channel', item
      render json: {success: true} 
    else
      render json: {success: false} 
    end
  end
  private
  def set_item
    @item = Item.find_by(item_id: params[:item_id])
  end
end