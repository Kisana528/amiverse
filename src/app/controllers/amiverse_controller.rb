class AmiverseController < ApplicationController
  before_action :logged_in_account, only: [:page1]
  def index
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
end