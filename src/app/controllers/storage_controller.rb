class StorageController < ApplicationController
  before_action :logged_in_account
  include Images
  before_action :set_image, only: %i[ show_image ]
  before_action :set_video, only: %i[ show_video ]
  def show_image
    send_noblob_stream(
      @image.image, @image.resize_image(@image.account.name, @image.account.name_id, 'image'))
  end
  def index
  end
  def images
    @images = Image.all
  end
  def new_image
    @image = Image.new
  end
  def create_image
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
  def videos
    @videos = Video.all
  end
  def new_video
    @video = Video.new
  end
  def create_video
    @video = Video.new(video_params)
    @video.video_id = unique_random_id(Video, 'video_id')
    if params[:video][:video].blank?
      flash.now[:danger] = "動画がありません。"
      return render 'new_videos'
    end
    capacity = @current_account.storage_max_size - @current_account.storage_size
    if params[:video][:video].size > capacity
      flash.now[:danger] = "ストレージ容量が足りません。"
      return render 'new_videos'
    end 
    video_type = content_type_to_extension(params[:video][:video].content_type)
    @video.video.attach(
      key: "accounts/#{@current_account.account_id}/videos/#{@video.video_id}.#{video_type}",
      io: (params[:video][:video]),
      filename: "video.#{video_type}"
    )
    @current_account.update(storage_size: @current_account.storage_size + @video.video.byte_size.to_i)
    @video.account_id = @current_account.id
    @video.uuid = SecureRandom.uuid
    if @video.save
      EncodeJob.perform_later(@video, @current_account)
      flash[:success] = "成功!"
      redirect_to storage_videos_path
    else
      flash.now[:danger] = "できませんでした。"
      render 'new_videos'
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
    @image = Image.find_by(image_id: params[:image_id],
                              deleted: false)
  end
  def set_video
    @video = Video.find_by(video_id: params[:video_id],
                              deleted: false)
  end
end