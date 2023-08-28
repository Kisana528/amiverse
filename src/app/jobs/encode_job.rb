class EncodeJob < ApplicationJob
  require 'aws-sdk-s3'
  queue_as :default

  def perform(video, account)
    Dir.mktmpdir do |dir|
      temp_file = Tempfile.new(['original_video', '.mp4'])
      video.video.open do |file|
        temp_file.write(file.read.force_encoding("UTF-8"))
      end
      movie = FFMPEG::Movie.new(temp_file.path)
      output_file = File.join(dir, 'output.m3u8')
      options = {
        custom: [
          '-hls_list_size', '0',
          '-hls_time', '10',
          '-hls_playlist_type', 'event',
          '-hls_segment_filename', File.join(dir, '%03d.ts')
        ]
      }
      movie.transcode(output_file, options) {
        |progress| video.update(description: (progress * 100).round(2))
      }
      s3 = Aws::S3::Resource.new(
        endpoint: 'http://minio:9000',
        region: 'amiverse',
        access_key_id: 'minioroot',
        secret_access_key: 'minioroot',
        force_path_style: true
      )

      Dir.glob("#{dir}/*").each do |file_path|
        file_name = File.basename(file_path)
        s3.bucket('development').object("variants/accounts/#{account.account_id}/videos/#{video.video_id}/#{file_name}").upload_file(file_path)
      end

      temp_file.close
    end
  end
end
