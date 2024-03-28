class V1::TimelinesController < V1::ApplicationController
before_action :api_logged_in_account, except: %i[ current ]    
  #skip_before_action :verify_authenticity_token
  def index
    @items = paged_items(params[:page])
    render json: items_data(@items)
  end
  def follow
    @items = @current_account.following
      .includes(:items)
      .map(&:items)
      .flatten.uniq
      .sort_by(&:created_at).reverse
    render json: @items.map {|item|
      item_data(item)
    }
  end
  def current
    @items = paged_items(params[:page])
    render json: items_data(@items)
  end
  def group
  end
  private
end