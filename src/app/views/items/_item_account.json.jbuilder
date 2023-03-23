json.account do
  json.extract! item.account, :account_id, :name, :name_id
end
json.extract! item, :item_id, :item_type, :flow, :meta, :content, :nsfw, :cw, :created_at, :updated_at