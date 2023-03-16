class Api::ApplicationController < ApplicationController
  protect_from_forgery except: :new
  def index
    status = { status: 'online' }
    render json: status
  end
  def logged_in
    if logged_in?
      render json: {logged_in: true, account_id: @current_account.account_id,
        name: @current_account.name,
        name_id: @current_account.name_id,
        icon_path: show_icon_url(@current_account.name_id)
      }
    else
      render json: { logged_in: false, message: 'ログインしてません。' }
    end
  end
  def new
    set_csrf_token_cookie
    render body: nil
  end
  private
  def api_admin_account
    unless logged_in? && @current_account.administrator
      render json: { message: "不正な操作" }
    end
  end
  def api_logged_in_account
    unless logged_in?
      render json: { message: "ログインして" }
    end
  end
  def api_logged_out_account
    unless !logged_in?
      render json: { message: "ログアウトして" }
    end
  end
  def set_csrf_token_cookie
    cookies['CSRF-TOKEN'] = {
      value: form_authenticity_token,
      domain: :all,
      expires: 1.year.from_now}
  end
  def set_csrf_token_header
    response.set_header('X-CSRF-Token', form_authenticity_token)
  end
end