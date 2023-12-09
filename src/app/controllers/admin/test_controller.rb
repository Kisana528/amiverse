class Admin::TestController < Admin::ApplicationController
  def new
  end
  def verify
    result = verify_signature(params[:public_key], params[:signature], params[:message])
    Rails.logger.info('-----結果発表------')
    Rails.logger.info(result ? 'ok' : 'ng')
    render 'index'
  end
  private
end