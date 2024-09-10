class AdminController < ApplicationController
  before_action :authenticate_admin!

  def index
    @requests = Request.all.order(created_at: :desc)
  end

  def user
    @user = User.find(params[:id])
  end

  def request_details
    @request = Request.find(params[:id])
  end

end
