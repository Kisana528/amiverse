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
  def signed_key_url(key, format = '.webp')
    dir = File.dirname(key)
    name = File.basename(key, '.*') + format
    true_key = File.join(dir, name)
    return generate_normal_url(true_key)
  end
  def signed_ati_url(account_id, type, image_id, format = ".webp")
    dir = "accounts/#{account_id}/#{type}"
    name = image_id + format
    true_key = File.join(dir, name)
    return generate_normal_url(true_key)
  end
  def full_api_url(path)
    return File.join(ENV["API_URL"], path)
  end
  private
  def generate_normal_url(true_key)
    variant_key = File.join('variants', true_key)
    bucket_key = File.join(ENV["S3_BUCKET"], variant_key)
    url = File.join(ENV["S3_ENDPOINT_1"], bucket_key)
    return url
  end
  def generate_signed_url(true_key)
    s3 = Aws::S3::Client.new(
      endpoint: ENV["S3_ENDPOINT_1"],
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
end
