module AccountsHelper
  def osp(path = '')
    if Rails.env.production?
      return "https://m.amiverse.net/#{path}"
    else
      return "http://192.168.0.4:9000/#{path}"
    end
  end
end