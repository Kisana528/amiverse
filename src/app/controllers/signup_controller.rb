class SignupController < ApplicationController
  before_action :logged_out_account, only: %i[p1 p2 p3]
  def index
  end
  def p1
  end
  def p2
    invitation = check_invitation_code(params[:invitation_code])
    if !invitation
      render 'p1' and return
    end
    session[:invitation_code] = params[:invitation_code]
    @account = Account.new
  end
  def p3
    @account = Account.new(account_params)
    invitation = check_invitation_code(session[:invitation_code])
    if !invitation
      render 'p2' and return
    end
    @account.account_id = unique_random_id(Account, 'account_id')
    key_pair = generate_rsa_key_pair
    @account.private_key = key_pair[:private_key]
    @account.public_key = key_pair[:public_key]
    #account_icon_banner_attach('')
    if @account.save
      invitation.update(uses: invitation.uses + 1)
      flash[:success] = "アカウントが作成されました"
      session[:invitation_code].clear
    else
      flash.now[:danger] = "間違っています。"
      render 'p2'
    end
  end
  private
  def account_params
    params.require(:account).permit(:name, :name_id, :bio, :location, :birthday, :password, :password_confirmation)
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
