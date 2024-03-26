module SessionsHelper
  def log_in(account)
    uuid = SecureRandom.uuid
    token = SecureRandom.urlsafe_base64
    Session.create(
      account_id: account.id,
      uuid: uuid,
      session_digest: digest(token)
    )
    secure_cookies = ENV["RAILS_SECURE_COOKIES"].present?
    cookies.permanent.signed[:amiverse_aid] = {
      value: account.aid,
      domain: :all,
      expires: 1.year.from_now,
      secure: secure_cookies,
      httponly: true
    }
    cookies.permanent.signed[:amiverse_uid] = {
      value: uuid,
      domain: :all,
      expires: 1.year.from_now,
      secure: secure_cookies,
      httponly: true
    }
    cookies.permanent.signed[:amiverse_rtk] = {
      value: token,
      domain: :all,
      expires: 1.year.from_now,
      secure: secure_cookies,
      httponly: true
    }
  end
  def logged_in?
    !@current_account.nil?
  end
  def current_account
    if @current_account
      return
    else
      begin
        account = Account.find_by(
          aid: cookies.signed[:amiverse_aid],
          deleted: false
        )
        session = Session.find_by(
          account_id: account.id,
          uuid: cookies.signed[:amiverse_uid],
          deleted: false
        )
        if BCrypt::Password.new(session.session_digest).is_password?(cookies.signed[:amiverse_rtk])
          @current_account = account
        end
      rescue
        @current_account = nil
      end
    end
  end
  def current_account?(account)
    account == current_account
  end
  def log_out
    Session.find_by(
      account_id: cookies.signed[:amiverse_aid],
      session_unique_id: cookies.signed[:amiverse_uid],
      deleted: false
    ).destroy
    cookies.delete(:amiverse_aid)
    cookies.delete(:amiverse_uid)
    cookies.delete(:amiverse_rtk)
    @current_account = nil
  end
  private
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
      BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
