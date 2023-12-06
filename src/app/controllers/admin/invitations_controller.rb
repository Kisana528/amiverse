class Admin::InvitationsController < Admin::ApplicationController
  def index
    @invitations = Invitation.all
  end
  def show
    @invitation = Invitation.find_by(invitation_code: params[:invitation_code])
  end
  def new
    @invitation = Invitation.new
  end
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.account_id = @current_account.id
    if @invitation.save
      flash[:success] = "招待を作成しました。"
      redirect_to root_path
    else
      render 'new'
    end
  end
  def edit
    @invitation = Invitation.find_by(invitation_code: params[:invitation_code])
  end
  def update
    @invitation = Invitation.find_by(invitation_code: params[:invitation_code])
    if @invitation.update(invitation_update_params)
      flash[:success] = '変更しました。'
      redirect_to admin_invitation_path(@invitation.invitation_code)
    else
      flash.now[:danger] = "更新できませんでした。"
      render 'edit'
    end
  end
  def destroy
    # 本当に消す？
  end
  private
  def invitation_params
    params.require(:invitation).permit(:name, :invitation_code, :max_uses, :expires_at)
  end
  def invitation_update_params
    params.permit(:account_id, :name, :invitation_code, :uses, :max_uses, :expires_at, :deleted)
  end
end