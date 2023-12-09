class Admin::TestController < Admin::ApplicationController
  def new
  end
  def verify
    #result = verify_signature(params[:public_key], params[:signature], params[:message])
    Rails.logger.info('-----結果発表------')
    Rails.logger.info(Digest::SHA256.digest(params[:message]))
    Rails.logger.info(Digest::SHA256.hexdigest(params[:message]))
    Rails.logger.info(Digest::SHA256.base64digest(params[:message]))
    #Rails.logger.info(result ? 'ok' : 'ng')
    render 'index'
  end
  private
end