class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_current_account
  private
  def admin_account
    unless logged_in? && @current_account.administrator
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
  # 謎？
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
  def unique_random_id(model, column)
    loop do
      urid = random_id
      if !model.exists?(column.to_sym => urid)
        return urid
        break
      end
    end
  end
  def account_icon_banner_attach  
    if !params[:account][:icon].blank?
      icon_type = content_type_to_extension(params[:account][:icon].content_type)
      @account.icon.attach(
        key: "accounts/#{@account.account_id}/icons/#{random_id}.#{icon_type}",
        io: (params[:account][:icon]),
        filename: "icon.#{icon_type}")
    end
    if !params[:account][:banner].blank?
      banner_type = content_type_to_extension(params[:account][:banner].content_type)
      @account.banner.attach(
        key: "accounts/#{@account.account_id}/banners/#{random_id}.#{banner_type}",
        io: (params[:account][:banner]),
        filename: "banner.#{banner_type}")
    end 
  end
  def content_type_to_extension(type)
    case type
      when 'image/jpeg' then 'jpg'
      when 'image/png'  then 'png'
      when 'image/gif'  then 'gif'
      when 'image/webp' then 'webp'
    end
  end
  def set_current_account
    @current_account = current_account
  end
end
