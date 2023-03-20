class Api::SessionsController < Api::ApplicationController
  before_action :api_logged_out_account, only: %i[ create ]
  def create
    account = Account.find_by(name_id: params[:name_id].downcase,
      activated: true,
      locked: false,
      silenced: false,
      suspended: false,
      frozen: false,
      deleted: false)
    if account && account.authenticate(params[:password])
      log_in account
      remember(account, request.remote_ip, request.user_agent, request.uuid)
      render json: { logged_in: true,
        message: "ログインしました。",
        account_id: account.account_id,
        name: account.name,
        name_id: account.name_id}
    else
      render json: { logged_in: false }
    end
  end
  def destroy
    if logged_in?
      log_out
      render json: { logged_in: false, message: "ログアウトしました。" }
    else
      render json: { message: "ログインしてないよ。" }
    end
  end
end