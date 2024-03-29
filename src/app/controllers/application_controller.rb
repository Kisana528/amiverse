class ApplicationController < ActionController::Base
  include ImageTreatment
  include ApplicationHelper
  include AccountsHelper
  include SessionsHelper
  require 'net/http'
  require 'net/https'
  before_action :set_current_account

  private
  def set_current_account
    @current_account = current_account
  end
  # アカウント関連
  def admin_account
    unless logged_in? && @current_account.administrator?
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    end
  end
  def logged_in_account
    unless logged_in?
      flash[:danger] = "ログインしてください"
      redirect_to login_path
    end
  end
  def logged_out_account
    unless !logged_in?
      flash[:danger] = "ログイン済みです"
      redirect_to root_path
    end
  end
  def correct_account(account)
    unless current_account?(account)
      flash[:danger] = "正しいユーザーでログインしてください"
      redirect_to root_path
    end
  end
  # その他
  def random_id
    ('a'..'z').to_a.concat(('A'..'Z').to_a.concat(('0'..'9').to_a)).shuffle[1..17].join
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
    private_key_pem = rsa_key.private_to_pem
    public_key_pem = rsa_key.public_to_pem
    { private_key: private_key_pem, public_key: public_key_pem }
  end
  def generate_signature(data, private_key_pem)
    private_key = OpenSSL::PKey::RSA.new(private_key_pem)
    signature = private_key.sign(OpenSSL::Digest::SHA256.new, data)
    return Base64.strict_encode64(signature)
  end
  def verify_signature(data, signature, public_key_pem)
    public_key = OpenSSL::PKey::RSA.new(public_key_pem)
    decoded_signature = Base64.strict_decode64(signature)
    return public_key.verify(OpenSSL::Digest::SHA256.new, decoded_signature, data)
  end
  def generate_varinat_image(image_aid, pre_image_aid, type)
    if image_aid.present? && pre_image_aid != image_aid
      image = Image.find_by(aid: image_aid)
      image.treat_image(type)
    end
  end
  def name_id_host_separater(str)
    name_id = ''
    host = ''
    if str.include?('@')
      parts = str.split('@')
      case parts.length
      when 3
        name_id, host = parts.pop(2)
      when 2
        if str.start_with?('@')
          name_id = parts.last
        else
          name_id, host = parts
        end
      when 1
        name_id = parts.first
      end
    else
      name_id = str
    end
    return name_id, host, (host.blank? || host == URI.parse(ENV['APP_HOST']).host)
  end
  def find_account_by_nid(nid)
    name_id, host, own_server = name_id_host_separater(nid)
    if own_server
      search_id = name_id
    else
      search_id = name_id + '@' + host
    end
    Account.find_by(name_id: search_id,
      activated: true,
      locked: false,
      silenced: false,
      suspended: false,
      frozen: false,
      deleted: false)
  end
  def paged_items(param)
    param = param.to_i
    page = param < 1 ? 1 : param
    offset_item = (page - 1) * 10 # 開始位置
    limit_item = 10 # 表示件数
    return Item.offset(offset_item.to_i).limit(limit_item.to_i).order(created_at: :desc)
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
        icon_url: image_url(item.account.icon_id, 'icon')
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
  def http_post(url, headers, data)
    uri = URI.parse(url)
    req = Net::HTTP.new(uri.host, uri.port)
    res = req.post(uri.path, data, headers)
    return req, res
  end
  def https_post(url, headers, data)
    uri = URI.parse(url)
    req = Net::HTTP.new(uri.host, uri.port)
    req.use_ssl = true
    res = req.post(uri.path, data, headers)
    return req, res
  end
  def https_get(url, headers)
    uri = URI.parse(url)
    req = Net::HTTP.new(uri.host, uri.port)
    req.use_ssl = true
    res = req.get(url, headers)
    return req, res
  end
end
