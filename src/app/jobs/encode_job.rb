class EncodeJob < ApplicationJob
  queue_as :default

  def perform(video, account)
    temp_file = Tempfile.new(['original_video', '.mp4'])
    video.video.open do |file|
      temp_file.write(file.read.force_encoding("UTF-8"))
    end
    transcoded_file = Tempfile.new(['transcoded_video', '.mp4'])
    movie = FFMPEG::Movie.new(temp_file.path)
    movie.transcode(transcoded_file.path, %w[-vcodec libx265 -acodec copy])
    video.encoded_video.attach(
      key: "variants/accounts/#{account.account_id}/videos/#{video.video_id}.mp4",
      io: File.open(transcoded_file.path),
      filename: "#{video.id}.mp4"
    )
    video.save!
    temp_file.close
  end
end
