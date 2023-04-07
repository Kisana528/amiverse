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
  def account_icon_banner_attach(type = '')
    if type == 'api'
      this_params = params
    else
      this_params = params[:account]
    end
    if !this_params[:icon].blank?
      icon_type = content_type_to_extension(this_params[:icon].content_type)
      @account.icon.attach(
        key: "accounts/#{@account.account_id}/icons/#{random_id}.#{icon_type}",
        io: (this_params[:icon]),
        filename: "icon.#{icon_type}")
    end
    if !this_params[:banner].blank?
      banner_type = content_type_to_extension(this_params[:banner].content_type)
      @account.banner.attach(
        key: "accounts/#{@account.account_id}/banners/#{random_id}.#{banner_type}",
        io: (this_params[:banner]),
        filename: "banner.#{banner_type}")
    end
  end
  def account_icon_banner_variant(type = '')
    if type == 'api'
      this_params = params
    else
      this_params = params[:account]
    end
    if !this_params[:icon].blank?
      @account.resize_image(@account.name, @account.name_id, 'icon')
    end
    if !this_params[:banner].blank?
      @account.resize_image(@account.name, @account.name_id, 'banner')
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
  def create_item_broadcast_format(item)
    account = Account.find(item.account_id)
    return_item = {
      account: {
        account_id: account.id,
        name: account.name,
        name_id: account.name_id
      },
      content: item.content,
      nsfw: item.nsfw,
      cw: item.cw,
      flow: item.flow,
      item_type: item.item_type,
      meta: item.meta,
      updated_at: item.updated_at,
      created_at: item.created_at,
      item_id: item.item_id,
    }
    return return_item
  end
end
