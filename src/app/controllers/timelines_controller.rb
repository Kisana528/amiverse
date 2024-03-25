class TimelinesController < ApplicationController
  before_action :logged_in_account, only: %i[ tl follow current group ]
  def index
    @items = paged_items(params[:page])
  end
  def tl
    redirect_to root_path
  end
  def follow
    @items = @current_account.following
      .includes(:items)
      .map(&:items)
      .flatten.uniq
      .sort_by(&:created_at).reverse
  end
  def current
    @items = paged_items(params[:page])
  end
  def group
  end
  private

end