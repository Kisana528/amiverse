class ReactionsController < ApplicationController
  before_action :logged_in_account
  #before_action :set_item, only: %i[ show edit update destroy ]
  def react
    emoji = Emoji.find_by(emoji_id: params[:emoji_id])
    item = Item.find_by(item_id: params[:item_id])
    this_react_params = {
      account_id: @current_account.id,
      emoji_id: emoji.id,
      item_id: item.id
    }
    if Reaction.exists?(this_react_params)
      Reaction.where(this_react_params).delete_all
      flash[:success] = 'リアクションを取り消しました'
    else
      react = Reaction.new(this_react_params)
      if react.save
        flash[:success] = 'リアクションしました'
      else
        flash[:danger] = '失敗しました'
      end
    end
    redirect_to item_path(item.item_id)
  end
  private
  def reaction_params
    params.require(:reaction).permit(
      :reaction_type,
      :content,
      :description,
      :category
    )
  end
end
