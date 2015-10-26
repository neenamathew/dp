json.array!(@photos) do |photo|
  json.extract! photo, :id, :file_name, :content_type, :user_id, :description, :binary_data
  json.url photo_url(photo, format: :json)
end
