class Admin::TestController < Admin::ApplicationController
  def new
  end
  def verify
    result = verify_signature(params[:public_key], params[:signature], params[:message])
    flash.now[:success] = result ? 'ok' : 'ng'
    render 'new'
  end
  def digest
    flash.now[:success] = Digest::SHA256.hexdigest(params[:digest]) + Digest::SHA256.base64digest(params[:digest])
    render 'new'
  end
  private
end