class Admin::TestController < Admin::ApplicationController
  include ActivityPub

  def index
  end
  def explore
  end
  def show
    @account = account(id_to_uri(params[:id]))
  end
  def new
  end
  def generate
    @key_pair = generate_rsa_key_pair
    flash.now[:success] = '生成成功'
    render 'new'
  end
  def verify
    context = HttpSignatures::Context.new(
      keys: {"https://misskey.io/users/9arqrxdfco#main-key" => {
        public_key: params[:public_key]
      }},
      algorithm: "rsa-sha256",
      headers: ["(request-target)", "Date", "Host", "Digest"],
    )
    uri = URI.parse(params[:url])
    req = Net::HTTP::Post.new(uri.path)
    req['Date'] = params[:date]
    req['Host'] = params[:host]
    req['Digest'] = params[:digest]
    req['Signature'] = params[:message]
    Rails.logger.info('=====ok?===')
    Rails.logger.info(context.verifier.valid?(req))
    ######################
    @verify = [params[:message], params[:signature], params[:public_key]]
    if result = verify_signature(params[:message], params[:signature], params[:public_key])
      if result
        flash.now[:success] = '認証成功'
      else
        flash.now[:danger] = '認証失敗'
      end
    else
      flash.now[:danger] = '例外'
    end
    render 'new'
  end
  def digest
    hexdigest = Digest::SHA256.hexdigest(params[:digest])
    base64digest = Digest::SHA256.base64digest(params[:digest])
    @digest = params[:digest]
    flash.now[:success] = "hexdigest: #{hexdigest},\nbase64digest: #{base64digest}"
    render 'new'
  end
  private
end