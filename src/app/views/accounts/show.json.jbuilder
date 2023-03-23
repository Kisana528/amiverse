json.items do
  json.array! @account.items, partial: "items/item", as: :item
end
json.extract! @account, :name_id, :name, :bio, :location, :birthday, :followers, :following, :items_count, :created_at, :updated_at