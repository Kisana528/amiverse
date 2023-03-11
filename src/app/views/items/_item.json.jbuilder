json.extract! item, :item_type, :flow, :meta, :content, :nsfw, :cw, :created_at, :updated_at
json.url item_url(item, format: :json)
