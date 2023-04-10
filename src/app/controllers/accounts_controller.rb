class AccountsController < ApplicationController
  include Images
  before_action :set_account, only: %i[ show_icon show_banner show ]
  before_action :logged_in_account, only: %i[edit update destroy password_edit password_update]
  def show_icon
    if @account.icon.attached?
      send_noblob_stream(
        @account.icon, @account.resize_image(@account.name, @account.name_id, 'icon'))
    else
      send_file('./app/assets/images/icon.webp')
    end
  end
  def show_banner
    if @account.banner.attached?
      send_noblob_stream(
        @account.banner, @account.resize_image(@account.name, @account.name_id, 'banner'))
    else
      send_file('./app/assets/images/banner.webp')
    end
  end
  def show
  end
  def edit
    @account = @current_account
  end
  def update
    @account = @current_account
    account_icon_banner_attach
    #account_icon_banner_set
    if !params[:account][:icon_id].blank?
      unless image = Image.find_by(image_id: params[:account][:icon_id])
        flash.now[:danger] = "アイコンなし"
        render 'edit' and return
      end
    end
    pre_icon_id = @account.icon_id
    if @account.update(account_update_params)
      #account_icon_banner_variant
      if params[:account][:icon_id].present? && pre_icon_id != params[:account][:icon_id]
        image = Image.find_by(image_id: params[:account][:icon_id])
        metadata = image.image.metadata
        metadata["icon"] = true
        image.image.update(metadata: metadata)
        image.resize_image(@account.name, @account.name_id, 'icon')
      end
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
