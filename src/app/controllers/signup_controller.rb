class SignupController < ApplicationController
  before_action :logged_out_account, only: %i[check new create create_admin]
  before_action :exists_admin, only: [:check]
  def index
  end
  def check
    render 'check' and return
  end
  def new
    invitation = check_invitation_code(params[:invitation_code])
    if !invitation
      render 'check' and return
    end
    session[:invitation_code] = params[:invitation_code]
    @account = Account.new
  end
  def create
    @account = Account.new(account_params)
    invitation = check_invitation_code(session[:invitation_code])
    if !invitation
      render 'new' and return
    end
    @account.account_id = unique_random_id(Account, 'account_id')
    @account.fediverse_id = URI.join(ENV['APP_HOST'], '@' + params[:account][:name_id])
    key_pair = generate_rsa_key_pair
    @account.private_key = key_pair[:private_key]
    @account.public_key = key_pair[:public_key]
    if @account.save
      invitation.update(uses: invitation.uses + 1)
      flash[:success] = "アカウントが作成されました"
      session[:invitation_code].clear
    else
      flash.now[:danger] = "間違っています。"
      render 'new'
    end
  end
  def create_admin
    @account = Account.new(account_params)
    @account.account_id = '00000000000000'
    @account.fediverse_id = URI.join(ENV['APP_HOST'], '@' + params[:account][:name_id])
    key_pair = generate_rsa_key_pair
    @account.private_key = key_pair[:private_key]
    @account.public_key = key_pair[:public_key]
    @account.activated = true
    @account.administrator = true
    if @account.save
      flash[:success] = "管理者アカウントが作成されました"
      render 'create'
    else
      flash.now[:danger] = "間違っています。"
      render 'new'
    end
  end
  private
  def account_params
    params.require(:account).permit(
      :name,
      :name_id,
      :bio,
      :location,
      :birthday,
      :password,
      :password_confirmation
    )
  end
  def check_invitation_code(invitation_code)
    invitation = Invitation.find_by(invitation_code: invitation_code)
    if !invitation
      flash.now[:danger] = "招待コードが有効ではありません。"
      return false
    elsif invitation.uses >= invitation.max_uses
      flash.now[:danger] = "招待コードの使用回数制限。"
      return false
    else
      return invitation
    end
  end  
end
