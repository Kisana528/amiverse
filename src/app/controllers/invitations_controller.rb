class InvitationsController < ApplicationController
  before_action :logged_in_account
  before_action :set_invitation, only: %i[ show ]
  def index
    @invitations = Invitation.all
      .where(deleted: false)
  end

  def show
    @invitation = Invitation.find_by(code: params[:code])
  end

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.account_id = @current_account.id
    @invitation.uuid = SecureRandom.uuid
    if @invitation.save
      flash[:success] = "招待を作成しました。"
      redirect_to root_path
    else
      render 'new'
    end
  end
  def edit
    @invitation = Invitation.find_by(code: params[:code])
  end
  def update
  end
  def delete
    @invitation = Invitation.find_by(code: params[:code])
    @invitation.update(deleted: true)
  end
  private
  def set_invitation
    @invitation = Invitation
      .find_by(code: params[:code])
      .where(deleted: false)
  end
  def invitation_params
    params.require(:invitation).permit(
      :name,
      :code,
      :max_uses,
      :expires_at
    )
  end
end
