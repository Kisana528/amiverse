class V1::AccountsController < V1::ApplicationController
  before_action :set_account, only: %i[ show ]
  def show
    render json: {name_id: @account.name_id,
      name: @account.name,
      icon_url: ati(@account.account_id, 'icon', @account.icon_id),
      banner_url: ati(@account.account_id, 'banner', @account.banner_id),
      bio: @account.bio,
      location: @account.location,
      birthday: @account.birthday,
      followers: @account.followers,
      following: @account.following,
      items_count: @account.items_count,
      created_at: @account.created_at,
      updated_at: @account.updated_at,
      public_key: @account.public_key,
      items: @account.items.map {|item| {
        item_id: item.item_id,
        item_type: item.item_type,
        flow: item.flow,
        meta: item.meta,
        content: item.content,
        cw: item.cw,
        version: item.version,
        created_at: item.created_at,
        updated_at: item.updated_at,
        reactions: item.reactions.group(:reaction_id).count.map { |key, value| {
          reaction_id: key,
          content: item.reactions.find_by(reaction_id: key).content,
          count: value
        }},
        images: item.images.map {|image| {
          image_id: image.image_id,
          name: image.name,
          description: image.description,
          url: ati(image.account.account_id, 'images', image.image_id)
        }}
      }}
    }
  end
  private
  def set_account
    @account = Account.find_by(
      name_id: params[:name_id],
      activated: true,
      locked: false,
      silenced: false,
      suspended: false,
      frozen: false,
      deleted: false
    )
  end
end