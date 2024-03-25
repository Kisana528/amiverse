class Admin::SessionsController < Admin::ApplicationController
  before_action :set_session, except: %i[ index ]

  def index
    @sessions = Session.all
  end
  def new
  end
  def create
  end
  def edit
  end
  def update
    if @session.update(session_update_params)
      flash[:success] = '変更しました'
      redirect_to admin_sessions_path
    else
      flash.now[:danger] = "変更できませんでした"
      render 'edit'
    end
  end
  def destroy
    if @session.update(deleted: true)
      flash[:success] = '変更しました'
      redirect_to admin_sessions_path
    else
      flash.now[:danger] = "変更できませんでした"
      redirect_to admin_sessions_path
    end
  end
  private
  def set_session
    @session = Session.find_by(uuid: params[:uuid])
  end
  def session_update_params
    params.require(:session).permit(
      :name,
      :remote_ip,
      :user_agent,
      :uuid,
      :session_digest,
      :deleted,
      :deleted_at,
      :created_at,
      :updated_at
    )
  end
end