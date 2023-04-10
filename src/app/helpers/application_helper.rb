module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Amiverse"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  def osp(key)
    format = '.webp'
    dir = File.dirname(key)
    name = File.basename(key, '.*') + format
    true_key = File.join(dir, name)
    if Rails.env.production?
      return "https://m.amiverse.net/production/variants/#{true_key}"
    else
      return "http://192.168.0.4:9000/development/variants/#{true_key}"
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
      return "http://192.168.0.4:9000/development/variants/#{true_key}"
    end
  end
end
