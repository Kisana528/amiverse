class StorageController < ApplicationController
  include DataStream
  before_action :logged_in_account
  before_action :set_video, only: %i[ show_video ]

  def show
    send_stream(filename: @video.video_id, type: @video.encoded_video.content_type) do |stream|
      @video.encoded_video.download do |chunk|
        stream.write(chunk)
      end
    end
  end
  def create
    @video = Video.new(video_params)
    @video.aid = unique_random_id(Video, 'aid')
    if params[:video][:video].blank?
      flash[:danger] = "動画がありません"
      return redirect_to settings_storage_path
    end
    capacity = @current_account.storage_max_size - @current_account.storage_size
    if params[:video][:video].size > capacity
      flash[:danger] = "ストレージ容量が足りません"
      return redirect_to settings_storage_path
    end 
    video_type = content_type_to_extension(params[:video][:video].content_type)
    @video.video.attach(
      key: "accounts/#{@current_account.aid}/videos/#{@video.aid}.#{video_type}",
      io: (params[:video][:video]),
      filename: "#{@video.aid}.#{video_type}"
    )
    @current_account.update(storage_size: @current_account.storage_size + @video.video.byte_size.to_i)
    @video.account = @current_account
    if @video.save
      EncodeJob.perform_later(@video, @current_account)
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
  def set_video
    @video = Video.find_by(
      aid: params[:aid],
      deleted: false
    )
  end
  def video_params
    params.require(:video).permit(
      :name,
      :description
    )
  end
end