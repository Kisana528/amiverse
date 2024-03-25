class NotificationsController < ApplicationController
  before_action :logged_in_account
  before_action :admin_account, only: %i[ new create ]
  def index
    @notifications = @current_account.notifications
  end
  def new
    @notification = Notification.new
  end
  def create
    @notification = Notification.new(notification_params)
    @account = Account.find_by(name_id: params[:notification][:name_id])
    @notification.account = @account
    @notification.uuid = SecureRandom.uuid
    if @notification.save!
      flash[:success] = "通知しました"
      redirect_to root_path
    else
      render 'new'
      flash[:danger] = "通知できませんでした"
    end
  end
  def delete
  end
  private
  def notification_params
    params.require(:notification).permit(
      :kind,
      :object,
      :message
    )
  end
end
