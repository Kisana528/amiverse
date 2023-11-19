class SettingsController < ApplicationController
  before_action :logged_in_account
  def index
    
  end
  def profile
    @images = Image.where(account_id: @current_account.id)
  end
  
  def storage
    @images = Image.where(account_id: @current_account.id)
    @videos = Video.where(account_id: @current_account.id)
    @image = Image.new
    @video = Video.new
  end
  def security_and_authority
    @sessions = Session.where(account_id: @current_account.id, deleted: false)
  end
end
