class SessionsController < ApplicationController
  def index
    @sessions = Session.where(account_id: current_account.id, deleted: false)
  end
  def new
  end
  def create
    account = Account.find_by(name_id: params[:session][:name_id].downcase)
    if account && account.authenticate(params[:session][:password])
      log_in account
      remember(account, request.remote_ip, request.user_agent, request.uuid)
      flash[:success] = "ログインしました。"
      redirect_to root_url
    else
      flash.now[:danger] = '間違っています。'
      render 'new'
    end
  end
  def destroy
    log_out if logged_in?
    flash[:success] = "ログアウトしました。"
    redirect_to root_url
  end
end
