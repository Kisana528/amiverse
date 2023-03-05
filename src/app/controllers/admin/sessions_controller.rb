class Admin::SessionsController < Admin::ApplicationController
  def index
    @sessions = Session.all
  end
  def show
    @session = Session.find_by(id: params[:id])
  end
  def edit
    @session = Session.find_by(id: params[:id])
  end
  def update
    @session = Session.find_by(id: params[:id])
  end
  def destroy
    @session = Session.find_by(id: params[:id])
  end
end