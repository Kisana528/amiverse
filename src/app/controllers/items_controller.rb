class ItemsController < ApplicationController
  before_action :logged_in_account, only: %i[ index show new create update destroy ]
  before_action :set_item, only: %i[ show edit update destroy ]
  def index
    offset_item = 1
    limit_item = 10
    offset_item = params[:o_i] unless params[:o_i].nil?
    limit_item = params[:l_i] unless params[:l_i].nil?

    @items = Item.offset(offset_item.to_i).limit(limit_item.to_i)
  end
  def show
    @reactions = Reaction.where(account_id: @current_account.id)
    # ?reactionが?個
  end
  def new
    @item = Item.new
  end
  def edit
  end
  def create
    @item = Item.new(item_params)
    @item.account_id = @current_account.id
    @item.item_id = unique_random_id(Item, 'item_id')
    @item.uuid = SecureRandom.uuid
    @item.item_type = 'plane'
    if @item.save
      flash[:success] = '投稿しました。'
      redirect_to item_url(@item.item_id)
      item = create_item_broadcast_format(@item)
      ActionCable.server.broadcast 'items_channel', item
    else
      render :new
    end
  end
  def update
    if @item.update(item_params)
      flash[:success] = '投稿を編集しました。'
      redirect_to item_url(@item.item_id)
    else
      render :edit
    end
  end
  def destroy
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  private
    def set_item
      @item = Item.find_by(item_id: params[:item_id])
    end
    def item_params
      params.require(:item).permit(:content,
                                  :nsfw,
                                  :cw)
    end
end
