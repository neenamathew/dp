class AdminController < ApplicationController
  before_filter :authenticate_user!

  def user_index
    @users = User.all.where("id != ?", current_user.id).search(params[:search]).page(params[:page]).per(8)
    authorize User
  end

  def group_index
    @groups = Group.all.search(params[:search]).page(params[:page]).per(8)
    authorize Group
  end

  def group_show
    @group = Group.find(params[:id])
    authorize @group
  end

end
