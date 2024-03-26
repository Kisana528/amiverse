class V1::SessionsController < V1::ApplicationController
  before_action :api_logged_out_account, only: %i[ create ]
  before_action :api_logged_in_account, only: %i[ destroy ]
  protect_from_forgery except: :new

  def new
    set_csrf_token_cookie
    render body: nil
  end
  def logged_in
    if logged_in?
      data_json = login_account_data(@current_account)
      data_json["logged_in"] = true
      render json: data_json
    else
      render json: { logged_in: false }
    end
  end
  def create
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
      remember(account, request.remote_ip, request.user_agent, request.uuid)
      render json: {
        logged_in: true,
        aid: account.aid,
        name: account.name,
        name_id: account.name_id,
        icon_url: generate_ati_url(account.account_id, 'icon', account.icon_id),
        banner_url: generate_ati_url(account.account_id, 'banner', account.banner_id)
      }
    else
      render json: { logged_in: false }, status: 401
    end
  end
  def update
  end
  def logout
    log_out
    render json: { logged_in: false }
  end
  def destroy
    render json: { }
  end
end