class AmiverseController < ApplicationController
  before_action :logged_in_account, only: [:page1]
  def index
    @items = Item.all.limit(5).order(created_at: :desc)
    @reactions = Reaction.all
  end
  def about
  end
  def info
  end
  def help
  end
  def policy
  end
  def disclaimer
  end
  def page1
  end
  def sitemap
  end
end