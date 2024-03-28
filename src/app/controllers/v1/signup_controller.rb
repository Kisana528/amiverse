class V1::SignupController < V1::ApplicationController
  before_action :logged_out_account, only: %i[ check create ]
  def check
    render json: { valid: Invitation.exists?(code: params[:code]) }
  end
  def create
    @account = Account.new(
      name: params[:name],
      name_id: params[:name_id],
      activitypub_id: URI.join(ENV['APP_HOST'], '@' + params[:name_id]),
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
    if Invitation.exists?(code: params[:code])
      @account.aid = unique_random_id(Account, 'aid')
      if @account.save
        render json: { status: 'created' }
      else
        render json: {
          status: 'rollbacked',
          message: @account.errors.full_messages.join(", ")
        }
      end
    else
      render json: { status: 'invalid_code' }
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
end