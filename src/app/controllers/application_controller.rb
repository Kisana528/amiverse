class ApplicationController < ActionController::Base
  include SessionsHelper
  private
  def admin_account
    unless logged_in? && current_account.administrator
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    end
  end
  def logged_in_account
    unless logged_in?
      redirect_to login_url
    end
  end
  def logged_out_account
    unless !logged_in?
      flash[:danger] = "ログイン済みです。"
      redirect_to root_url
    end
  end
  def correct_account
    @account = current_account
    unless current_account?(@account)
      flash[:danger] = "正しいユーザーでログインしてください。"
      redirect_to(root_url)
    end
  end
  def random_id
    ('a'..'z').to_a.concat(('1'..'9').to_a).shuffle[1..14].join
  end
  def content_type_to_extension(type)
    case type
      when 'image/jpeg' then 'jpg'
      when 'image/png'  then 'png'
      when 'image/gif'  then 'gif'
      when 'image/webp' then 'webp'
    end
  end
end
