class StorageController < ApplicationController
  before_action :logged_in_account
  include Images
  before_action :set_image, only: %i[ show_image ]
  before_action :set_video, only: %i[ show_video ]
  def show_image
    send_noblob_stream(
      @image.image, @image.resize_image(@image.account.name, @image.account.name_id, 'image'))
  end
  def show_video
    send_stream(filename: @video.video_id, type: @video.encoded_video.content_type) do |stream|
      @video.encoded_video.download do |chunk|
        stream.write(chunk)
      end
    end
  end
  def index
  end
  def images
    @images = Image.where(account_id: @current_account.id)
  end
  def new_image
    @image = Image.new
  end
  def create_image
    @image = Image.new(image_params)
    @image.aid = unique_random_id(Image, 'aid')
    if params[:image][:image].blank?
      flash.now[:danger] = "画像がありません"
      return render 'new_image'
    end
    capacity = @current_account.storage_max_size - @current_account.storage_size
    if params[:image][:image].size > capacity
      flash.now[:danger] = "ストレージ容量が足りません"
      return render 'new_image'
    end 
    image_type = content_type_to_extension(params[:image][:image].content_type)
    @image.image.attach(
      key: "accounts/#{@current_account.aid}/images/#{@image.aid}.#{image_type}",
      io: (params[:image][:image]),
      filename: "#{@image.aid}.#{image_type}"
    )
    @current_account.update(storage_size: @current_account.storage_size + @image.image.byte_size.to_i)
    @image.account_id = @current_account.id
    @image.uuid = SecureRandom.uuid
    if @image.save
      @image.resize_image(@current_account.name, @current_account.name_id, 'image')
      flash[:success] = "アップロードしました"
      redirect_to storage_images_path
    else
      flash.now[:danger] = "アップロードできませんでした"
      render 'new_image'
    end
  end
  def videos
    @videos = Video.all
  end
  def new_video
    @video = Video.new
  end
  def create_video
    @video = Video.new(video_params)
    @video.aid = unique_random_id(Video, 'aid')
    if params[:video][:video].blank?
      flash.now[:danger] = "動画がありません"
      return render 'new_video'
    end
    capacity = @current_account.storage_max_size - @current_account.storage_size
    if params[:video][:video].size > capacity
      flash.now[:danger] = "ストレージ容量が足りません"
      return render 'new_video'
    end 
    video_type = content_type_to_extension(params[:video][:video].content_type)
    @video.video.attach(
      key: "accounts/#{@current_account.aid}/videos/#{@video.aid}.#{video_type}",
      io: (params[:video][:video]),
      filename: "#{@video.aid}.#{video_type}"
    )
    @current_account.update(storage_size: @current_account.storage_size + @video.video.byte_size.to_i)
    @video.account_id = @current_account.id
    @video.uuid = SecureRandom.uuid
    if @video.save
      EncodeJob.perform_later(@video, @current_account)
      flash[:success] = "アップロードしました"
      redirect_to storage_videos_path
    else
      flash.now[:danger] = "アップロードできませんでした"
      render 'new_video'
    end
  end
  private
  def image_params
    params.require(:image).permit(:name, :description)
  end
  def video_params
    params.require(:video).permit(:name, :description)
  end
  def set_image
    @image = Image.find_by(
      aid: params[:image_id],
      deleted: false
    )
  end
  def set_video
    @video = Video.find_by(
      aid: params[:aid],
      deleted: false
    )
  end
end