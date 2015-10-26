# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Role.where(:role_type => 'admin').first_or_create(:id => 1)
Role.where(:role_type => 'user_create_group').first_or_create(:id => 2)
Role.where(:role_type => 'user').first_or_create(:id => 3)
p user = User.where(:first_name => 'admin').first_or_create!(:email => "admin@gmail.com",:password => "admin@gmail.com",:user_name => "admin",:last_name =>"admin")
p user.errors
UserRole.where(:user_id => user.id).first_or_create!(:role_id => 1)
Group.where(:name => 'public').first_or_create(:user_id => user.id)
puts "ff"