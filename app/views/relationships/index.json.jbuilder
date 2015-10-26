json.array!(@relationships) do |relationship|
  json.extract! relationship, :id, :follower_id, :followed_id
  json.url relationship_url(relationship, format: :json)
end
