class AccountsController < ApplicationController
  include Images
  before_action :set_account, only: %i[ show_icon show_banner show ]
  before_action :logged_in_account, only: %i[edit update destroy password_edit password_update]
  def show_icon
    if @account.icon.attached? 
      send_noblob_stream(
        @account.icon, @account.resize_image(@account.name, @account.name_id, 'icon'))
    end
  end
  def show_banner
    send_noblob_stream(
      @account.banner, @account.resize_image(@account.name, @account.name_id, 'banner'))
  end
  def show
  end
  def edit
    @account = @current_account
  end
  def update
    @account = @current_account
    account_icon_banner_attach
    if @account.update(account_update_params)
      flash[:success] = "更新成功!"
      redirect_to account_path(@account.name_id)
    else
      flash.now[:danger] = "更新できませんでした。"
      render 'edit'
    end
  end
  def password_edit
    @account = @current_account
  end
  def password_update
    @user = current_user
    if @user.update(user_params)
      flash[:success] = "更新成功!"
      redirect_to user_path(@user.user_id)
    else
      render 'edit'
    end
  end
  def destroy
  end
  private
  def set_account
    @account = Account.find_by(name_id: params[:name_id],
                              activated: true,
                              locked: false,
                              silenced: false,
                              suspended: false,
                              frozen: false,
                              deleted: false)
  end
  def account_params
    params.require(:account).permit(:name,
                                    :name_id,
                                    :bio,
                                    :location,
                                    :birthday,
                                    :password,
                                    :password_confirmation)
  end
  def account_update_params
    params.require(:account).permit(:name,
                                    :name_id,
                                    :bio,
                                    :location,
                                    :birthday)
  end
end