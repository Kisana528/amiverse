class SignupController < ApplicationController
  before_action :logged_out_account, only: %i[check new create create_admin]
  def index
  end
  def check # 招待コードの入力
    if Account.first.blank?
      @account = Account.new
      render 'entry'
    end
  end
  def entry # アカウント情報の入力
    if Account.first.blank?
      @account = Account.new
    else
      invitation = check_invitation_code(params[:code])
      if invitation
        session[:code] = params[:code]
        @account = Account.new
      else
        render 'check'
      end
    end
  end
  def create
    @account = Account.new(account_params)
    if Account.first.blank?
      @account.activated = true
      @account.administrator = true
    else
      invitation = check_invitation_code(session[:code])
      unless invitation
        render 'entry'
        return
      end
    end
    @account.aid = unique_random_id(Account, 'aid')
    @account.fediverse_id = URI.join(ENV['APP_HOST'], '@' + params[:account][:name_id])
    key_pair = generate_rsa_key_pair
    @account.private_key = key_pair[:private_key]
    @account.public_key = key_pair[:public_key]
    if @account.save
      if invitation
        invitation.update(uses: invitation.uses + 1)
        session[:code].clear
      end
      flash[:success] = "アカウントが作成されました"
      redirect_to login_path
    else
      flash.now[:danger] = "間違っています。"
      render 'entry'
    end
  end
  private
  def account_params
    params.require(:account).permit(
      :name,
      :name_id,
      :summary,
      :location,
      :birthday,
      :password,
      :password_confirmation
    )
  end
  def check_invitation_code(code)
    invitation = Invitation.find_by(code: code)
    if !invitation
      flash.now[:danger] = "招待コードが無効です"
      return false
    elsif invitation.uses >= invitation.max_uses
      flash.now[:danger] = "招待コードの使用回数が上限に達しています"
      return false
    elsif invitation.deleted
      flash.now[:danger] = "削除された招待コードです"
      return false
    else
      flash[:success] = "有効な招待コードです"
      return invitation
    end
  end
end
