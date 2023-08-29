module ApplicationHelper
  require 'aws-sdk-s3'
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
  def ati(account_id, type, image_id, format = '.webp')
    dir = "accounts/#{account_id}/#{type}"
    name = image_id + format
    true_key = File.join(dir, name)
    s3 = Aws::S3::Client.new(
      endpoint: ENV["S3_ENDPOINT_0"],
      region: ENV["S3_REGION"],
      access_key_id: ENV["S3_USER"],
      secret_access_key: ENV["S3_PASSWORD"],
      force_path_style: true
    )
    signer = Aws::S3::Presigner.new(client: s3)
    url = signer.presigned_url(
      :get_object,
      bucket: ENV["S3_BUCKET"],
      key: "variants/#{true_key}",
      expires_in: 12,)
    return url
  end
  def full_api_url(path)
    if Rails.env.production?
      return "https://api.amiverse.net/#{path}"
    else
      return "http://localhost:3000/#{path}"
    end
  end
end
