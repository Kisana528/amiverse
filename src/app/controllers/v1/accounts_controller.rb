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
      items: @account.items.map {|item| {
        content: item.content,
        item_id: item.item_id,
        created_at: item.created_at
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