module UsersHelper
  def role_list
    options_for_select(Role.all.collect{|u| [u.role_type]})
  end

end
