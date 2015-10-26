class UsersController < ApplicationController

  before_filter :authenticate_user! , :except => [ :update_password, :change_password]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  #List all users other than current_user and users with role_type admin
  def index
    @users = User.search(params[:search]).page(params[:page]).per(9)
    authorize User
  end

  def show
    @groups = @user.groups.all
    @photo = Photo.new
  end

  def new
    @user = User.new
  end

  def edit
    authorize @user
  end

  #Create user and assign role, sent mail for editing the user profile
  def create
    @user = User.new(user_params)
    @user.password =  Devise.friendly_token.first(8)
    @user.token =  Devise.friendly_token.first(8)
    authorize @user
    if params[:role_type] != nil
      role = Role.find_by(role_type: params[:role_type])
    end
    group = Group.find_by(name: "public")
    if @user.save
      @user.user_groups.find_or_create_by(group_id: group.id , user_id: @user.id).save
      if role != nil then
        role.user_roles.new(user_id: @user.id ,role_id: role.id).save
      else
        role = Role.find_by(role_type: "user_create_group")
        role.user_roles.new(user_id: @user.id ,role_id: role.id).save
      end
      UserMailer.welcome_email(@user).deliver_now
      redirect_to admin_user_index_users_path
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params[:role_type] != nil
      role = Role.find_by(role_type: params[:role_type])
    end
    if role != nil then
      @user.user_role.role_id = role.id
    else
      role = Role.find_by(role_type: "user_create_group")
      role.user_roles.new(user_id: @user.id ,role_id: role.id).save
    end
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, alert: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to admin_user_index_users_path
  end

  def change_password
    @user = User.find_by(token: params[:id])
    if @user.blank?
      flash[:alert] = "Link expired"
      redirect_to root_path
    end  
  end

  def update_password
    @user = User.find_by(token: params[:id])
    if @user.update_attributes(change_password_params)
      @user.token =  Devise.friendly_token.first(8)
      @user.save
      redirect_to @user
    else
      redirect_to change_password_user_path
    end
  end

  def update_profile_picture
    if params[:user] != nil then
      @user = User.find_by(id: params[:id])
      authorize @user
      if @user.update_attributes(change_profile_picture_params)
        @user.followers.each do |user_follow|
          user_follow.notifications.new(message: " #{@user.user_name} has changed profile picture").save
        end
        redirect_to @user
      else
        redirect_to @user
      end
    else
      redirect_to current_user
    end
  end

  private

  def check_access
    if current_user
      user_role = current_user.user_role.role.role_type
      if user_role != "admin"
        flash[:error] = "Permission denied "
        redirect_to user_path(current_user.id)
      end
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role_type, :user_name)
  end

  def change_password_params
    params.require(:user).permit( :password, :password_confirmation)
  end

  def change_profile_picture_params
    params.require(:user).permit(:image)
  end

end
