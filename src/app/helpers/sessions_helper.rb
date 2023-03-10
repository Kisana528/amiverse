module SessionsHelper
  def log_in(account)
    session[:account_id] = account.account_id
  end
  def current_account
    if cookies.signed[:amiverse_aid]
      account = Account.find_by(account_id: cookies.signed[:amiverse_aid])
      if account && account.authenticated?(
          cookies.signed[:amiverse_uid],
          cookies.signed[:amiverse_rtk])
        log_in account
        @current_account = account
      end
    end
  end
  def current_account?(account)
    account == current_account
  end
  def logged_in?
    !@current_account.nil?
  end
  def log_out
    forget(@current_account)
    session.delete(:account_id)
    @current_account = nil
  end
  def remember(account, remote_ip, user_agent, uuid)
    remember_token = Account.new_token
    account.remember(remember_token, remote_ip, user_agent, uuid)
    ENV["RAILS_SECURE_COOKIES"].present? ? secure_cookies = true : secure_cookies = false
    cookies.permanent.signed[:amiverse_aid] = {
      value: account.account_id,
      domain: :all,
      expires: 1.year.from_now,
      secure: secure_cookies,
      httponly: true }
    cookies.permanent.signed[:amiverse_uid] = {
      value: uuid,
      domain: :all,
      expires: 1.year.from_now,
      secure: secure_cookies,
      httponly: true }
    cookies.permanent.signed[:amiverse_rtk] = {
      value: remember_token,
      domain: :all,
      expires: 1.year.from_now,
      secure: secure_cookies,
      httponly: true }
  end
  def forget(account)
    account.forget(cookies.signed[:amiverse_uid])
    cookies.delete(:amiverse_aid)
    cookies.delete(:amiverse_uid)
    cookies.delete(:amiverse_rtk)
  end
  def db_destroy(account)
    account.forget(cookies.signed[:amiverse_uid])
  end
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
