class SignupController < ApplicationController
  before_action :logged_out_account, only: %i[p1 p2 p3]
  def index
  end
  def p1
  end
  def p2
    if Invitation.exists?(invitation_code: params[:invitation_code])
      session[:invitation_code] = params[:invitation_code]
      @account = Account.new
    else
      flash.now[:danger] = "招待コードが有効ではありません。"
      render 'p1'
    end
  end
  def p3
    @account = Account.new(account_params)
    if Invitation.exists?(invitation_code: session[:invitation_code])
      loop do
        account_id = ('a'..'z').to_a.concat(('1'..'9').to_a).shuffle[1..14].join
        if !Account.exists?(account_id: account_id)
          @account.account_id = account_id
          break
        end
      end
      if @account.save
        flash[:success] = "アカウントが作成されました"
        session[:invitation_code].clear
      else
        flash.now[:danger] = "間違っています。"
        render 'p2'
      end
    else
      flash.now[:danger] = "招待コードが有効ではありません。"
      render 'p2'
    end
  end
  private
  def account_params
    params.require(:account).permit(:name, :name_id, :bio, :location, :birthday, :password, :password_confirmation)
  end
end
