class GroupsController < ApplicationController

  before_action :set_group, only: [:show, :edit, :update, :destroy, :send_mail_on_request]
  before_filter :authenticate_user!

  def index
    @groups = Group.all.search(params[:search]).page(params[:page]).per(10)
    authorize Group
  end

  def show
  end

  def new
    @group = Group.new
  end

  def edit
    authorize @group
  end

  # Create a group and assign user as a member of group
  def create
    @group = Group.new(group_params)
    user = User.find_by(id: current_user.id)
    @group.user_id = user.id
    respond_to do |format|
      if @group.save
        if current_user.user_role.role.role_type == "admin" then
          url_= admin_group_show_user_path(@group)
        else
          url_= group_path(@group)
        end

        user.user_groups.new(user_id: user.id ,group_id: @group.id).save
        format.html { redirect_to url_, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @group
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @group
    @group.destroy
    if (current_user.email == "admin@gmail.com")
      redirect_to admin_group_index_users_path
    else
      redirect_to user_path(current_user)

    end
  end

  #send mail on request to join group
  def send_mail_on_request
    user_created_group = User.find_by(id: @group.user_id)
    UserMailer.user_group_join_request(current_user,user_created_group,@group).deliver_now
    redirect_to group_path, notice: 'Request Mail was successfully sent.'
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :user_ids => [])
  end

end
