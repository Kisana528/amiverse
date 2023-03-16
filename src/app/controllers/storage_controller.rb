class StorageController < ApplicationController
  before_action :logged_in_account
  include Images
  before_action :set_image, only: %i[ show_image ]
  def show_image
    send_noblob_stream(
      @image.image, @image.resize_image(@image.account.name, @image.account.name_id, 'image'))
  end
  def index
  end
  def images
    @images = Image.all
  end
  def new_images
    @image = Image.new
  end
  def create_images
    @image = Image.new(image_params)
    @image.image_id = unique_random_id(Image, 'image_id')
    if params[:image][:image].blank?
      flash.now[:danger] = "画像がありません。"
      return render 'new_images'
    end
    capacity = @current_account.storage_max_size - @current_account.storage_size
    if params[:image][:image].size > capacity
      flash.now[:danger] = "ストレージ容量が足りません。"
      return render 'new_images'
    end 
    image_type = content_type_to_extension(params[:image][:image].content_type)
    @image.image.attach(
      key: "accounts/#{@current_account.account_id}/images/#{@image.image_id}.#{image_type}",
      io: (params[:image][:image]),
      filename: "image.#{image_type}"
    )
    @current_account.update(storage_size: @current_account.storage_size + @image.image.byte_size.to_i)
    @image.account_id = @current_account.id
    @image.uuid = SecureRandom.uuid
    if @image.save
      flash[:success] = "成功!"
      redirect_to storage_images_path
    else
      flash.now[:danger] = "できませんでした。"
      render 'new_images'
    end
  end
  private
  def image_params
    params.require(:image).permit(:name, :description)
  end
  def set_image
    @image = Image.find_by(image_id: params[:image_id],
                              deleted: false)
  end
end