class Admin::ApplicationController < ApplicationController
  before_action :admin_account
  def index
  end
end