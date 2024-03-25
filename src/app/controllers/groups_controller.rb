class GroupsController < ApplicationController
  before_action :logged_in_account
  def index
    @groups = Group.all
  end
  def new
    @group = Group.new
  end
  def create
    @group = Group.new(group_params)
    @group.account = @current_account
    @group.aid = unique_random_id(Group, 'aid')
    if @group.save
      flash[:success] = '作成しました'
      redirect_to groups_path
    else
      flash[:danger] = '作成できませんでした'
      render 'new'
    end
  end
  def group_add
    group = Group.find_by(aid: params[:group_aid])
    account = Account.find_by(aid: params[:account_aid])
    group.accounts << account
    if group.save
      flash[:success] = '追加しました'
      redirect_to groups_path
    else
      flash[:danger] = '追加できませんでした'
      render 'new'
    end
  end
  def group_remove
    group = Group.find_by(aid: params[:group_aid])
    account = Account.find_by(aid: params[:account_aid])
    group.accounts.delete(account)
    if group.save
      flash[:success] = '削除しました'
      redirect_to groups_path
    else
      flash[:danger] = '削除できませんでした'
      render 'new'
    end
  end
  def show
    @group = Group.find_by(aid: params[:aid])
  end
  private
  def group_params
    params.require(:group).permit(
      :name,
      :description
    )
  end
end
