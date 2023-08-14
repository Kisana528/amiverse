class EncodeJob < ApplicationJob
  queue_as :default

  def perform(video, account)
    Dir.mktmpdir do |dir|
      temp_file = Tempfile.new(['original_video', '.mp4'])
      video.video.open do |file|
        temp_file.write(file.read.force_encoding("UTF-8"))
      end
      #transcoded_file = Tempfile.new(['transcoded_video', '.mp4'])
      movie = FFMPEG::Movie.new(temp_file.path)
      #movie.transcode(transcoded_file.path, %w[-vcodec libx265 -acodec copy])
      #video.encoded_video.attach(
      #  key: "variants/accounts/#{account.account_id}/videos/#{video.video_id}.mp4",
      #  io: File.open(transcoded_file.path),
      #  filename: "#{video.id}.mp4"
      #)
      output_file = File.join(dir, 'output.m3u8')
      options = {
        hls_list_size: 0, # セグメントの数。0にすると無限
        hls_time: 10, # セグメントの長さ（秒）
        hls_flags: 'delete_segments', # 古いセグメントを削除
        hls_playlist_type: 'event', # 'event'にするとライブ配信形式になる
        hls_segment_filename: File.join(dir, '%03d.ts') # セグメントのファイル名の形式
      }
      movie.transcode(output_file, options)

      s3_config = Rails.application.config.active_storage.service_configurations['minio']
      s3 = Aws::S3::Resource.new(
        endpoint: 'http://minio:9000',
        region: 'amiverse',
        access_key_id: 'minioroot',
        secret_access_key: 'minioroot',
        force_path_style: true
      )

      s3.bucket('development').object(`variants/accounts/#{account.account_id}/videos/#{video.video_id}`).upload_stream('')
      Dir.glob("#{dir}/*").each do |file_path|
        s3.bucket('development').object(`variants/accounts/#{account.account_id}/videos/#{video.video_id}`).upload_file(file_path)
      end

      video.save!
      temp_file.close
    end
  end
end
