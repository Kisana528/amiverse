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
  def generate_key_url(key, format = '.webp') # imageがあるとき用
    dir = File.dirname(key)
    name = File.basename(key, '.*') + format
    true_key = File.join(dir, name)
    return generate_normal_url(true_key)
  end
  def generate_ati_url(account_aid, type, image_aid, format = ".webp") # accountとimageのaidがあるとき
    dir = "accounts/#{account_aid}/#{type}"
    name = image_aid + format
    true_key = File.join(dir, name)
    return generate_normal_url(true_key)
  end
  def full_api_url(path)
    return File.join(ENV["API_URL"], path)
  end
  def to_page(current_page, where_to_go)
    current_page = current_page.to_i
    page = where_to_go == 'next' ? [current_page + 1, 2].max : where_to_go == 'prev' ? [current_page - 1, 1].max : 2
    return page
  end
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
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
