class ResourcesController < ApplicationController
  before_action :logged_in_account, only: [:page1]
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
  def resources
  end
end