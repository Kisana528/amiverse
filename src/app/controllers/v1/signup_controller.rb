class V1::SignupController < V1::ApplicationController
  before_action :logged_out_account, only: %i[check_invitation_code create]
  def check_invitation_code
    if Invitation.exists?(invitation_code: params[:invitation_code])
      render json: { invitation_code: true }
    else
      render json: { invitation_code: false }
    end
  end
  def create
    @account = Account.new(
      name: params[:name],
      name_id: params[:name_id],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
    if Invitation.exists?(invitation_code: params[:invitation_code])
      @account.account_id = unique_random_id(Account, 'account_id')
      account_icon_banner_attach('api')
      if @account.save
        render json: { created: true }
      else
        render json: { created: false }
      end
    else
      render json: { invitation_code: false }
    end
  end
  private
  def account_params
    params.require(:account).permit(:name, :name_id, :bio, :location, :birthday, :password, :password_confirmation)
  end
end