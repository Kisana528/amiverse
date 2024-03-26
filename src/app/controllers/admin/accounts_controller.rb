class Admin::AccountsController < Admin::ApplicationController
  before_action :set_account, except: %i[ index ]

  def index
    @accounts = Account.all
  end
  def new
  end
  def create
  end
  def edit
  end
  def update
    if @account.update(account_update_params)
      flash[:success] = '変更しました'
      redirect_to admin_accounts_path
    else
      flash.now[:danger] = "変更できませんでした"
      render 'edit'
    end
  end
  def destroy
    if @account.update(deleted: true)
      flash[:success] = '変更しました'
      redirect_to admin_accounts_path
    else
      flash.now[:danger] = "変更できませんでした"
      redirect_to admin_accounts_path
    end
  end
  private
  def set_account
    @account = Account.find_by(aid: params[:aid])
  end
  def account_update_params
    params.require(:account).permit(
      :name, :name_id, :bio, :location, :birthday,
      :authenticated, :public_visibility, :role, :activated,
      :administrator, :moderator, :sensitive, :explorable,
      :locked, :silenced, :suspended, :frozen, :deleted
    )
  end
end