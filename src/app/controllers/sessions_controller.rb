class SessionsController < ApplicationController
  before_action :logged_in_account, only: %i[ index destroy ]
  before_action :logged_out_account, only: %i[ new create ]
  def index
    @sessions = Session.where(account_id: @current_account.id, deleted: false)
  end
  def new
  end
  def create
    account = Account.find_by(name_id: params[:session][:name_id].downcase,
      activated: true,
      locked: false,
      silenced: false,
      suspended: false,
      frozen: false,
      deleted: false)
    if account && account.authenticate(params[:session][:password])
      log_in account
      flash[:success] = t('.success')
      redirect_to root_url
    else
      flash.now[:danger] = '間違っています。'
      render 'new'
    end
  end
  def edit
  end
  def update
  end
  def logout
    log_out if logged_in?
    flash[:success] = "ログアウトしました。"
    redirect_to root_url
  end
  def delete
    session = Session.find(params[:id])
    if session.update(deleted: true)
      flash[:success] = "更新成功!"
      redirect_to root_url
    else
      flash.now[:danger] = "更新できませんでした。"
      render 'settings/security_and_authority'
    end
  end
end
