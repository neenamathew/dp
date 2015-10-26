class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  def index
    @photos = Photo.all
  end

  def show
  end

  def new
    @photo = Photo.new
  end

  def edit
  end

  def create
    @user  = current_user
    if params.has_key? :photo
      @photo = Photo.new(photo_params)
      @photo.user_id = current_user.id
      respond_to do |format|
        if @photo.save
          format.html { redirect_to @user }
          format.json { render :show, status: :created, location: @photo }
        else
          format.html { render :new }
          format.json { render json: @photo.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to @user
    end

  end

  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url, notice: 'Photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def code_image
    @image_data = Photo.find(params[:id])
    @image = @image_data.binary_data
    send_data(@image, :type => @image_data.content_type, :filename => @image_data.file_name,
              :disposition => 'inline')
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:image_file)
  end
end
