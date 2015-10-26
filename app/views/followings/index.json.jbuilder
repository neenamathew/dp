json.array!(@followings) do |following|
  json.extract! following, :id, :user_name, :email, :first_name
  json.url following_url(following, format: :json)
end
