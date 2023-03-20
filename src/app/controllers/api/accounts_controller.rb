class Api::AccountsController < Api::ApplicationController
  before_action :set_account, only: %i[ show ]
  def index
  end
  def show
    render json: {name_id: @account.name_id,
      name: @account.name,
      bio: @account.bio,
      location: @account.location,
      birthday: @account.birthday,
      followers: @account.followers,
      following: @account.following,
      items_count: @account.items_count,
      created_at: @account.created_at}
  end
  private
  def set_account
    @account = Account.find_by(name_id: params[:name_id],
                              activated: true,
                              locked: false,
                              silenced: false,
                              suspended: false,
                              frozen: false,
                              deleted: false)
  end
end