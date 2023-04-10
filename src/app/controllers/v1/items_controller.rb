class V1::ItemsController < V1::ApplicationController
  before_action :api_logged_in_account, only: %i[ create ]
  before_action :set_item, only: %i[ show ]
  def index
    @items = Item.all
    render json: @items.map {|item| {
      content: item.content,
      item_id: item.item_id,
      created_at: item.created_at,
      account: {
        name_id: item.account.name_id,
        name: item.account.name,
        icon_url: ati(item.account.account_id, 'icon', item.account.icon_id)
      },
      reactions: item.reactions.group(:reaction_id).count.map { |key, value| {
        reaction_id: key,
        content: item.reactions.find_by(reaction_id: key).content,
        count: value
      }}
    }}
  end
  def show
    #render json: @item
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