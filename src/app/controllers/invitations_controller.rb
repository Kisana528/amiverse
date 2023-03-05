class InvitationsController < ApplicationController
  def index
    @invitations = Invitation.all
  end

  def show
    @invitation = Invitation.find_by(id: params[:id])
  end

  def new
    @Invitation = Invitation.new
  end

  def create
    @Invitation = Invitation.new(invitation_params)
    @Invitation.account_id = current_account.id
    if @Invitation.save
      flash[:success] = "招待を作成しました。"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end
  def update
  end

  def delete
  end
  private
  def invitation_params
    params.permit(:name, :invitation_code, :max_uses, :expires_at)
  end
end
