class Admin::TestController < Admin::ApplicationController
  include ActivityPub

  def index
  end
  def explore
  end
  def show
    @account = explore_account(id_to_uri(params[:id]))
  end
  def new
  end
  def create_key
    pri, pub = generate_rsa_key_pair
    Rails.logger.info('======目印======')
    Rails.logger.info(pri)
    Rails.logger.info(pub)
  end
  def verify
    result = verify_signature(params[:public_key], params[:signature], params[:message].to_json)
    Rails.logger.info('======目印======')
    Rails.logger.info(result ? 'ok' : 'ng')
    render 'new'
  end
  def digest
    tmp = Digest::SHA256.hexdigest(params[:digest]) + Digest::SHA256.base64digest(params[:digest])
    Rails.logger.info('======目印======')
    Rails.logger.info(tmp)
    render 'new'
  end
  private
end