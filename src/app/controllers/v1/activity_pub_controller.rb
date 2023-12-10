class V1::ActivityPubController < V1::ApplicationController
  def inbox
    # frontで受け取ったactivityを解析・保存
    data = JSON.parse(request.body.read)
    # digest
    digest = Digest::SHA256.base64digest(data.body.to_json)
    received_digest = data.headers.digest.split('=')[1]
    signature = data.headers.signature
    segments = signature.split(',')
    obj_segments = {}
    segments.each do |segment|
      key, value = segment.split('=')
      key = key.gsub('"', '').strip
      value = value.gsub('"', '').strip
      obj_segments[key] = value
    end
    
    Rails.logger.info(digest == received_digest ? 'ok dgt' : 'no dgt')
    ActivityPubReceived.create(content: data.to_json)
    render json: { status: 'success', message: 'Post created successfully' }
  end
  def outbox
    # データ出力
  end
end