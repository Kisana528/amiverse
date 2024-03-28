class AccountsController < ApplicationController
  include ActivityPub
  before_action :set_account, except: %i[ show ]
  before_action :logged_in_account, except: %i[ show ]

  def show
    @account = find_account_by_nid(params[:name_id])
  end
  def follow
    account = find_account_by_nid(params[:name_id])
    this_follow_params = {
      followed: account,
      follower: @current_account
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
  def update
    @account = @current_account
    if @account.update(account_update_params)
      treat_image(@account.icon_id, 'icon') if @account.icon_id.present? # 更新されたときのみ実行が好ましい
      treat_image(@account.banner_id, 'banner') if @account.banner_id.present? # 更新されたときのみ実行が好ましい
      flash[:success] = "更新しました"
      redirect_to account_path(@account.name_id)
    else
      flash[:danger] = "更新できませんでした#{@account.errors.full_messages.join(", ")}"
      redirect_to settings_account_path
    end
  end
  def password_update
    @user = current_user
    if @user.update(user_params)
      flash[:success] = "更新しました"
      redirect_to user_path(@user.user_id)
    else
      flash[:danger] = "更新できませんでした"
      redirect_to settings_account_path
    end
  end
  def destroy
  end
  private
  def set_account
    @account = Account.find_by(name_id: params[:name_id])
  end
  def account_params
    params.require(:account).permit(
      :name,
      :name_id,
      :icon_id,
      :banner_id,
      :summary,
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
      :summary,
      :location,
      :birthday
    )
  end
  def account_password_update_params
    params.require(:account).permit(
      :password,
      :password_confirmation
    )
  end
end