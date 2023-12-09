class ItemsController < ApplicationController
  before_action :logged_in_account, only: %i[ index show new create update destroy ]
  before_action :set_item, only: %i[ show edit update destroy ]
  include ActivityPub

  def index
    offset_item = 0
    limit_item = 9
    offset_item = params[:o_i] unless params[:o_i].nil?
    limit_item = params[:l_i] unless params[:l_i].nil?

    @items = Item.offset(offset_item.to_i).limit(limit_item.to_i)
  end
  def show
    # ?reactionが?個
  end
  def new
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
      if params[:item][:selected_images].present?
        params[:item][:selected_images].each do |image_id|
          if image = Image.find_by(image_id: image_id)
            this_item_image_params = {
              image_id: image.id,
              item_id: @item.id
            }
            ItemImage.create(this_item_image_params)
          end
        end
      end
      if reply_to = Item.find_by(item_id: params[:item][:reply_item_id])
        Reply.create(reply_from: @item, reply_to: reply_to)
      end
      if quote_to = Item.find_by(item_id: params[:item][:quote_item_id])
        Quote.create(quote_from: @item, quote_to: quote_to)
      end
      flash[:success] = '投稿しました。'
      redirect_to item_url(@item.item_id)
      item = create_item_broadcast_format(@item)
      
      from_url = 'https://amiverse.net'
      to_url = 'https://mstdn.jp/inbox'
      from_url = params[:item][:from_url] unless params[:item][:from_url].empty?
      to_url = params[:item][:to_url] unless params[:item][:to_url].empty?
      front_deliver(create_note(@item), @current_account.name_id, @current_account.private_key, from_url, to_url, @current_account.public_key)
      ActionCable.server.broadcast 'items_channel', item
    else
      flash[:success] = '失敗しました。'
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
                                  :cw)
    end
end
