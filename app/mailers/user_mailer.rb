class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    @url  = 'https://frozen-gorge-6924.herokuapp.com/users/'+user.token.to_s+'/change_password'
    @url_log_in = 'https://frozen-gorge-6924.herokuapp.com/users/sign_in'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def user_group_join_request(user,user_group,group)
    @user = user_group
    @request_user = user
    @group = group
    @url_log_in = 'https://frozen-gorge-6924.herokuapp.com/users/sign_in'
    mail(to: @user.email, subject: 'Request to join group')
  end
end
