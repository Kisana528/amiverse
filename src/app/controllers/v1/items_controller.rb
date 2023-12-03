class V1::ItemsController < V1::ApplicationController
  before_action :api_logged_in_account, only: %i[ create ]
  before_action :set_item, only: %i[ show ]

  def index
    @items = paged_items(params[:page])
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
      ActionCable.server.broadcast 'items_channel', item
      to_host = 'mstdn.jp'
      current_time = Time.now
      formatted_time = current_time.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
      to_be_signed = "(request-target): post /inbox\nhost: #{to_host}\ndate: #{formatted_time}"
      account_private_key = @item.account.private_key

      sign = generate_signature(to_be_signed, account_private_key)
      item['time'] = formatted_time
      item['host'] = to_host
      item['sign'] = sign
      item['signed_data'] = to_be_signed
      header = 'keyId="https://amiverse.net/@' + @item.account.name_id + '#main-key",headers="(request-target) host date",signature="' + sign + '"'
      res = https_req(
        'https://mstdn.jp/inbox',
        { 'Content-Type' => 'application/activity+json',
          'Host' => to_host,
          'Date' => formatted_time,
          'Signature' => header
        },
        create_wrap(@item).to_json
      )
      Rails.logger.info('------request------')
      Rails.logger.info(res)
      Rails.logger.info(res.body)
      
      render json: {success: true} 
    else
      render json: {success: false} 
    end
  end
  private
  def set_item
    @item = Item.find_by(item_id: params[:item_id])
  end
  def create_wrap(item)
    {
      "@context": "https://www.w3.org/ns/activitystreams",
      "type": "Create",
      "id": "https://amiverse.net/items/#{item.item_id}/create",
      "published": item.created_at,
      "to": [
        "https://amiverse.net/#{item.account.name_id}/followers",
        "https://www.w3.org/ns/activitystreams#Public"
      ],
      "actor": "https://amiverse.net/#{item.account.name_id}",
      "object": {
        "@context": "https://www.w3.org/ns/activitystreams",
        "type": "Note",
        "id": "https://amiverse.net/items/#{item.item_id}",
        "url": "https://amiverse.net/items/#{item.item_id}",
        "published": item.created_at,
        "to": [
          "https://amiverse.net/#{item.account.name_id}/followers",
          "https://www.w3.org/ns/activitystreams#Public"
        ],
        "attributedTo": "https://amiverse.net/#{item.account.name_id}/followers",
        "content": item.content
      }
    }
  end 
end