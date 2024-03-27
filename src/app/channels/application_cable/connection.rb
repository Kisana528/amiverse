module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include SessionsHelper
    identified_by :current_account
    def connect
      self.current_account = current_account
    end
  end
end
