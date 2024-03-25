class MessagesController < ApplicationController
  before_action :logged_in_account
  def index
    @groups = Group.all
  end
  def show
    @group = Group.find_by(aid: params[:group_aid])
    @messages = @group.messages
  end
  def create
    @group = Group.find_by(aid: params[:group_aid])
    @message = Message.new(message_params)
    @message.account = @current_account
    @message.group = @group
    @message.uuid = SecureRandom.uuid
    if @message.save
      flash[:success] = '送信しました'
      redirect_to message_path(@group.aid)
    else
      flash[:danger] = '失敗'
      redirect_to message_path(@group.gaid)
    end
  end
  private
  def message_params
    params.require(:message).permit(
      :kind,
      :content
    )
  end
end
