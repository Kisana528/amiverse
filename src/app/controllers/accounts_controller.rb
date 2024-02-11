class AccountsController < ApplicationController
  include Images
  include ActivityPub
  before_action :set_account, only: %i[ show ]
  before_action :logged_in_account, only: %i[edit update destroy password_edit password_update]
  def show
  end
  def follow
    account = find_account_by_nid(params[:name_id])
    this_follow_params = {
      follow_to_id: account.account_id,
      follow_from_id: @current_account.account_id
    }
    if account.outsider
      if Follow.exists?(this_follow_params)
        follow = Follow.find_by(this_follow_params)
        undo_follow(follow_to: account, follow_from: @current_account, uid: follow.uid)
        follow.delete
        flash[:success] = 'フォロー取り消し依頼しました'
      else
        this_follow_params.merge!({uid: SecureRandom.uuid})
        Rails.logger.info(this_follow_params[:uid])
        follow = Follow.new(this_follow_params)
        if follow.save!
          ap_follow(follow_to: account, follow_from: @current_account, uid: this_follow_params[:uid])
          flash[:success] = 'フォロー依頼しました'
        else
          flash[:danger] = 'フォロー依頼できません'
        end
      end
    else
      if Follow.exists?(this_follow_params)
        Follow.where(this_follow_params).delete_all
        flash[:success] = 'フォローを取り消しました'
      else
        this_follow_params.merge!({accepted: true})
        follow = Follow.new(this_follow_params)
        if follow.save!
          flash[:success] = 'フォローしました'
        else
          flash[:danger] = '失敗しました'
        end
      end
    end
    redirect_to root_path
  end
  def edit
    @account = @current_account
  end
  def update
    @account = @current_account
    pre_icon_id = @account.icon_id
    pre_banner_id = @account.banner_id
    if @account.update(account_update_params)
      generate_varinat_image(params[:account][:icon_id], pre_icon_id, 'icon')
      generate_varinat_image(params[:account][:banner_id], pre_banner_id, 'banner')
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
    params.require(:account).permit(
      :name,
      :name_id,
      :icon_id,
      :banner_id,
      :bio,
      :location,
      :birthday,
      :password,
      :password_confirmation
    )
  end
  def account_update_params
    params.require(:account).permit(
      :name,
      :name_id,
      :icon_id,
      :banner_id,
      :bio,
      :location,
      :birthday
    )
  end
end