# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb_user do
    process :resize_to_height => [150]
  end

  version :thumb do
    process :resize_to_fit => [50, 50]
  end

  version :thumb_show do
    process :resize_to_height => [80]
  end


  def resize_to_height(height)
    manipulate! do |img|
      if img.rows >= height

        img.resize_to_fit!(img.columns, height)
      else
        height by height.fo_f

        img.resize_to_fit!(2 * (img.columns * height.to_f / img.rows).ceil, height)
      end
      img = yield(img) if block_given?
      img
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    ActionController::Base.helpers.asset_path([thumb, "Thumbnail.png"].compact.join('_'))
  #[thumb, "ima.png"].compact.join('_')
  #"default.jpg"

  end



end
