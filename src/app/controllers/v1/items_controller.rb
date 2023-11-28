class V1::ItemsController < V1::ApplicationController
  before_action :api_logged_in_account, only: %i[ create ]
  before_action :set_item, only: %i[ show ]
  require "net/http"

  def index
    @items = Item.all
    render json: @items.map {|item|
      serialize_item(item)
    }
  end
  def show
    #render json: @item
  end
  def create
    @item = Item.new(
      content: params[:content],
      cw: params[:cw]
    )
    @item.account_id = @current_account.id
    @item.item_id = unique_random_id(Item, 'item_id')
    @item.uuid = SecureRandom.uuid
    @item.item_type = 'plane'
    if @item.save
      item = serialize_item(@item)
      
      #uri = URI.parse("http://front:3000/api/create_object")
      #req = Net::HTTP.new(uri.host, uri.port)
      #res = req.post(uri.path, item.to_json)

      #http_req(
      #  'http://front:3000/api/create_object/',
      #  item.to_json
      #)
      ActionCable.server.broadcast 'items_channel', item
      #to_host = 'misskey.io'
      #current_time = Time.now
      #formatted_time = current_time.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
      #to_be_signed = `(request-target): post /inbox
      #host: #{to_host}
      #date: #{formatted_time}`
      #account_private_key = @item.account.private_key
      #sign = generate_signature(to_be_signed, account_private_key)
      #item['sign'] = sign
      #http_req(
      #  'http://front:3000/api/create_object/',
      #  item.to_json
      #)
      #ActionCable.server.broadcast 'items_channel', item
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