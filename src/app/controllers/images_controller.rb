class ImagesController < ApplicationController
  include DataStream
  before_action :logged_in_account
  before_action :set_image

  def show
    send_noblob_stream(
      @image.image, @image.resize_image(@image.account.name, @image.account.name_id, 'image'))
  end
  def create
    @image = Image.new(image_params)
    @image.aid = unique_random_id(Image, 'aid')
    if params[:image][:image].blank?
      flash[:danger] = "画像がありません"
      return redirect_to settings_storage_path
    end
    capacity = @current_account.storage_max_size - @current_account.storage_size
    if params[:image][:image].size > capacity
      flash[:danger] = "ストレージ容量が足りません"
      return redirect_to settings_storage_path
    end 
    image_type = content_type_to_extension(params[:image][:image].content_type)
    @image.image.attach(
      key: "accounts/#{@current_account.aid}/images/#{@image.aid}.#{image_type}",
      io: (params[:image][:image]),
      filename: "#{@image.aid}.#{image_type}"
    )
    @current_account.update(storage_size: @current_account.storage_size + @image.image.byte_size.to_i)
    @image.account = @current_account
    if @image.save
      @image.resize_image(@current_account.name, @current_account.name_id, 'image')
      flash[:success] = "アップロードしました"
      redirect_to settings_storage_path
    else
      flash[:danger] = "アップロードできませんでした"
      redirect_to settings_storage_path
    end
  end
  def update
  end
  def destroy
  end
  private
  def set_image
    @image = Image.find_by(
      aid: params[:aid],
      deleted: false
    )
  end
  def image_params
    params.require(:image).permit(:name, :description)
  end
end