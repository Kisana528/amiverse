module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_account
    def connect
      self.current_account = current_account
    end
    private
    def current_account
      if cookies.signed[:amiverse_aid]
        account = Account.find_by(account_id: cookies.signed[:amiverse_aid])
        if account && account.authenticated?(
            cookies.signed[:amiverse_uid],
            cookies.signed[:amiverse_rtk])
          return account
        end
      end
    end
  end
end
