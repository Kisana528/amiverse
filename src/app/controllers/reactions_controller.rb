class ReactionsController < ApplicationController
  before_action :logged_in_account
  #before_action :set_item, only: %i[ show edit update destroy ]
  def index
    @reactions = Reaction.all
  end
  def new
    @reaction = Reaction.new
  end
  def create
    @reaction = Reaction.new(reaction_params)
    @reaction.account_id = @current_account.id
    @reaction.reaction_id = unique_random_id(Reaction, 'reaction_id')
    if @reaction.save
      flash[:success] = '作成しました。'
      redirect_to reactions_path
    else
      render :new
    end
  end
  def react
    @reaction = Reaction.find_by(reaction_id: params[:reaction_id])
    item = Item.find_by(item_id: params[:item_id])
    this_react_params = {
      account_id: @current_account.id,
      reaction_id: @reaction.id,
      item_id: item.id
    }
    if AccountReactionItem.exists?(this_react_params)
      AccountReactionItem.where(this_react_params).delete_all
      flash[:success] = 'リアクションを取り消しました'
    else
      react = AccountReactionItem.new(this_react_params)
      if react.save
        flash[:success] = 'リアクションしました'
      else
        flash[:success] = '失敗しました'
      end
    end
    redirect_to items_path
  end
  private
  def reaction_params
    params.require(:reaction).permit(:reaction_type,
                                :content,
                                :description,
                                :category)
  end
end
