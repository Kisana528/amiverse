class Admin::AccountsController < Admin::ApplicationController
  def index
    @accounts = Account.all
  end
  def show
    @account = Account.find_by(name_id: params[:name_id])
  end
  def new
  end
  def create
  end
  def generate_key
    @account = Account.find_by(name_id: params[:name_id])
    key_pair = OpenSSL::PKey::RSA.generate(2048)
    # 秘密鍵の出力
    private_key = key_pair.to_pem
    # 公開鍵の出力
    public_key = key_pair.public_key.to_pem
    @account.update(public_key: public_key, private_key: private_key)
    flash[:success] = '生成しました。'
    redirect_to admin_account_path(@account.name_id)
  end
  def edit
    @account = Account.find_by(name_id: params[:name_id])
  end
  def update
    @account = Account.find_by(name_id: params[:name_id])
    if @account.update(account_update_params)
      flash[:success] = '変更しました。'
      redirect_to admin_account_path(@account.name_id)
    else
      flash.now[:danger] = "更新できませんでした。"
      render 'edit'
    end
  end
  def destroy
    # 本当に消す？
  end
  private
  def account_update_params
    params.require(:account).permit(
      :name, :name_id, :bio, :location, :birthday,
      :authenticated, :public_visibility, :role, :activated,
      :administrator, :moderator, :nsfw, :explorable,
      :locked, :silenced, :suspended, :frozen, :deleted)
  end
end