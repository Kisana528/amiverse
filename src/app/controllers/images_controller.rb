class ImagesController < ApplicationController
  include DataStream
  before_action :logged_in_account
  before_action :set_image

  def show
    send_noblob_stream(
      @image.image,
      treat_image(@image.aid, 'image')
    )
  end
  def show_icon
    send_noblob_stream(
      @image.image,
      treat_image(@image.aid, 'icon')
    )
  end
  def show_banner
    send_noblob_stream(
      @image.image,
      treat_image(@image.aid, 'banner')
    )
  end
  def create
    @image = Image.new(image_params)
    if params[:image][:image].blank?
      flash[:danger] = "画像がありません"
      return redirect_to settings_storage_path
    end
    @image.account = @current_account
    extension = File.extname(params[:image][:image].original_filename).delete_prefix(".")
    @image.aid = unique_random_id(Image, 'aid')
    @image.image.attach(
      key: "/images/#{@image.aid}.#{extension}",
      io: (params[:image][:image]),
      filename: "#{@image.aid}.#{extension}"
    )
    @image.name = params[:image][:image].original_filename if @image.name.blank?
    if @image.save
      treat_image(@image.aid, 'image')
      @current_account.update(storage_size: @current_account.storage_size + @image.image.byte_size.to_i)
      flash[:success] = "アップロードしました"
      redirect_to settings_storage_path
    else
      flash[:danger] = "アップロードできませんでした#{@image.errors.full_messages.join(", ")}"
      redirect_to settings_storage_path
    end
  end
  def update
  end
  def destroy
  end
  private
  def set_image
    @image = Image.where(
      'BINARY aid = ? AND deleted = ?',
      params[:aid],
      false
    ).first
  end
  def image_params
    params.require(:image).permit(
      :name,
      :description,
      :sensitive,
      :warning_message,
      :private
    )
  end
end