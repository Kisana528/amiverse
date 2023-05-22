module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Amiverse"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  def osp(key, format = '.webp')
    dir = File.dirname(key)
    name = File.basename(key, '.*') + format
    true_key = File.join(dir, name)
    if Rails.env.production?
      return "https://m.amiverse.net/production/variants/#{true_key}"
    else
      return "http://localhost:9000/development/variants/#{true_key}"
    end
  end
  def ati(account_id, type, image_id)
    format = '.webp'
    dir = "accounts/#{account_id}/#{type}"
    name = image_id + format
    true_key = File.join(dir, name)
    if Rails.env.production?
      return "https://m.amiverse.net/production/variants/#{true_key}"
    else
      return "http://localhost:9000/development/variants/#{true_key}"
    end
  end
  def full_api_url(path)
    if Rails.env.production?
      return "https://api.amiverse.net/#{path}"
    else
      return "http://localhost:3000/#{path}"
    end
  end
end
