class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper
  require 'net/https'
  before_action :set_current_account
  private
  def exists_admin
    if Account.all.empty?
      @account = Account.new
      render 'signup/new' and return
    end
  end
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
  def generate_rsa_key_pair
    rsa_key = OpenSSL::PKey::RSA.new(2048)
    private_key_pem = rsa_key.to_pem
    public_key_pem = rsa_key.public_key.to_pem
    { private_key: private_key_pem, public_key: public_key_pem }
  end
  def generate_signature(data, private_key_pem)
    private_key = OpenSSL::PKey::RSA.new(private_key_pem)
    signature = private_key.sign(OpenSSL::Digest::SHA256.new, data)
    return Base64.strict_encode64(signature)
  end
  def generate_varinat_image(image_id, pre_image_id, type)
    if image_id.present? && pre_image_id != image_id
      image = Image.find_by(image_id: image_id)
      image.resize_image(@account.name, @account.name_id, type)
    end
  end
  def find_account_by_nid(nid)
    Account.find_by(name_id: nid,
      activated: true,
      locked: false,
      silenced: false,
      suspended: false,
      frozen: false,
      deleted: false)
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
    return serialize_item(item)
  end
  def serialize_item(item)
    return {
      content: item.content,
      item_id: item.item_id,
      created_at: item.created_at,
      account: {
        name_id: item.account.name_id,
        name: item.account.name,
        icon_url: generate_ati_url(item.account.account_id, 'icon', item.account.icon_id)
      },
      reactions: item.reactions.group(:reaction_id).count.map { |key, value| {
        reaction_id: key,
        content: item.reactions.find_by(reaction_id: key).content,
        count: value
      }},
      items_to: item.reply_to_items.map {|item| {
        item_id: item.item_id
      }},
      items_from: item.reply_from_items.map {|item| {
        item_id: item.item_id
      }}
    }
  end
  def http_req(url, data)
    uri = URI.parse(url)
    req = Net::HTTP.new(uri.host, uri.port)
    #request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
    #request.body = data.to_json
    #response = http.request(request)
    res = req.post(uri.path, data)
  end
end
