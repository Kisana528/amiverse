class Ap::AccountsController < Ap::ApplicationController
  before_action :set_account, only: %i[ show ]
  def show
    render json: {
      "@context": "https://www.w3.org/ns/activitystreams",
      type: "Person",
      id: "https://example.com/users/kisana",
      name: @account.name,
      preferredUsername: @account.name_id,
      inbox: full_api_url("#{@account.name_id}/inbox"),
      outbox: full_api_url("#{@account.name_id}/outbox"),
      followers: full_api_url("#{@account.name_id}/followers"),
      following: full_api_url("#{@account.name_id}/following")
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