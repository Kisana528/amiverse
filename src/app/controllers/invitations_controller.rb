class InvitationsController < ApplicationController
  before_action :logged_in_account
  def index
    @invitations = Invitation.all
  end

  def show
    @invitation = Invitation.find_by(id: params[:id])
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
  end
  def update
  end

  def delete
  end
  private
  def invitation_params
    params.require(:invitation).permit(:name, :invitation_code, :max_uses, :expires_at)
  end
end
