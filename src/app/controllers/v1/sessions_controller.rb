class V1::SessionsController < V1::ApplicationController
  before_action :api_logged_out_account, only: %i[ create ]
  before_action :api_logged_in_account, only: %i[ destroy ]
  protect_from_forgery except: :new

  def new
    set_csrf_token_cookie
    render body: nil
  end
  def check
    if logged_in?
      render json: {
        logged_in: true,
        account: login_account_data(@current_account)
      }
    else
      render json: { logged_in: false }
    end
  end
  def login
    account = Account.find_by(name_id: params[:name_id].downcase,
      activated: true,
      locked: false,
      silenced: false,
      suspended: false,
      frozen: false,
      deleted: false
    )
    if account && account.authenticate(params[:password])
      log_in account
      render json: { logged_in: true }
    else
      render json: { logged_in: false }, status: 401
    end
  end
  def logout
    log_out if logged_in?
    render json: { logged_in: false }
  end
  # 確認用
  def index
  end
  def update
  end
  def destroy
    render json: { }
  end
end