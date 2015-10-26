class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  layout :layout_by_resource
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(resource)
    if current_user.user_role.role.role_type == "admin"
      admin_user_index_users_path
    else
      group_posts_path(current_user.id)
    end
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  private

  def user_not_authorized
    flash[:alert1] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def layout_by_resource
    if current_user
      if current_user.user_role.role.role_type == "admin"
        "application"
      else
        "user_layout"
      end
    else
      reset_session
      "user_layout"
    end
  end

end
