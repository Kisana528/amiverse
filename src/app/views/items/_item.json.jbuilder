json.extract! item, :id, :item_id, :uuid, :item_type, :flow, :meta, :content, :nsfw, :cw, :version, :deleted, :created_at, :updated_at
json.url item_url(item, format: :json)
