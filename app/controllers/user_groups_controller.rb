class UserGroupsController < ApplicationController

  # Add a user to group and redirection based on role
  def add_group_user
    group_detail = Group.find(params[:id])
    user = User.select("id").find_by(user_name: params[:name])
    user_ = User.find_by(user_name: params[:name])
    if user
      authorize user.user_groups.new(group_id: group_detail.id , user_id: user.id)
      if user.user_groups.find_or_create_by(group_id: group_detail.id , user_id: user.id).save
        flash[:notice] = "#{params[:name]} was successfully added to the group"
        group_detail.users.each do |group_user|
          if group_user.id != current_user.id
            group_user.notifications.new(message:" new user - #{user_.user_name} is added to the #{group_detail.name}").save
          end
        end
        redirection
      else
        redirection
      end
    else
      flash[:error] = "User was not added"
      redirection
    end
  end

  #Destroy and redirection based on role
  def destroy
    user = User.find_by(id: params[:user_id])
    authorize user.user_groups.find_by(group_id: params[:group_id])
    group_detail = Group.find_by(id: params[:group_id])
    if user.user_groups.find_by(group_id: params[:group_id]).destroy
      flash[:notice] = "User was successfully removed from the group"
       group_detail.users.each do |group_user|
          if group_user.id != current_user.id
            group_user.notifications.new(message:" user - #{user.user_name} has been removed from the #{group_detail.name}").save
          end
        end
      redirection
    else
      flash[:error] = "User was not removed"
      redirect_to group_path and return
    end
  end

  private

  #Redirection based on role
  def redirection
    if current_user.user_role.role.role_type == "admin"
      redirect_to admin_group_show_user_path and return
    else
      redirect_to group_path and return
    end
  end

end
