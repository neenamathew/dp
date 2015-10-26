module GroupsHelper
  def user_list
    if current_user
      admin_ids = Role.find_by(role_type: "admin").user_roles.ids
      @users = User.all.where("id != ? AND id NOT IN (?)", current_user.id , admin_ids)
      options_for_select(@users.collect{|u| [u.user_name]})
    end
  end
end
