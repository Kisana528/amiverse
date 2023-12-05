class V1::ActivityPubController < V1::ApplicationController
  def inbox
    # frontで受け取ったactivityを解析・保存
    data = JSON.parse(request.body.read)
    Rails.logger.info(data.to_json)
    ActivityPubReceived.create(content: data.to_json)
    render json: { status: 'success', message: 'Post created successfully' }
  end
  def outbox
    # データ出力
  end
end