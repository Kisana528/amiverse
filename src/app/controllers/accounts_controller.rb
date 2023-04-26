class AccountsController < ApplicationController
  include Images
  before_action :set_account, only: %i[ show ]
  before_action :logged_in_account, only: %i[edit update destroy password_edit password_update]
  def show
  end
  def edit
    @account = @current_account
  end
  def update
    @account = @current_account
    pre_icon_id = @account.icon_id
    pre_banner_id = @account.banner_id
    if @account.update(account_update_params)
      check_and_variant_image(params[:account][:icon_id], pre_icon_id, 'icon')
      check_and_variant_image(params[:account][:banner_id], pre_banner_id, 'banner')
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
    @account = find_account_by_nid(params[:name_id])
  end
  def account_params
    params.require(:account).permit(:name,
                                    :name_id,
                                    :icon_id,
                                    :banner_id,
                                    :bio,
                                    :location,
                                    :birthday,
                                    :password,
                                    :password_confirmation)
  end
  def account_update_params
    params.require(:account).permit(:name,
                                    :name_id,
                                    :icon_id,
                                    :banner_id,
                                    :bio,
                                    :location,
                                    :birthday)
  end
end
