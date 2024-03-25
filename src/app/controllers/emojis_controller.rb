class EmojisController < ApplicationController
  before_action :logged_in_account
  #before_action :set_item, only: %i[ show edit update destroy ]
  def index
    @emojis = Emoji.all
  end
  def show
  end
  def new
    @emoji = Emoji.new
  end
  def create
    @emoji = Emoji.new(emoji_params)
    @emoji.account_id = @current_account.id
    @emoji.emoji_id = unique_random_id(Emoji, 'emoji_id')
    if @emoji.save
      flash[:success] = '作成しました。'
      redirect_to emojis_path
    else
      render :new
    end
  end
  def edit
  end
  def update
  end
  def destroy
  end
  private
  def emoji_params
    params.require(:emoji).permit(
      :emoji_type,
      :content,
      :description,
      :category
    )
  end
end
