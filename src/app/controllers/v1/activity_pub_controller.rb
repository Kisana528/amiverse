class V1::ActivityPubController < V1::ApplicationController
  def inbox
    # frontで受け取ったactivityを解析・保存
    data = JSON.parse(request.body.read)
    # frontから来たか検証
    # digestやsignなど検証
    # データ処理
    ActivityPubReceived.create(received_at: data['received_at'].to_s,
    headers: data['headers'].to_json,
    body: data['body'].to_json)
    render json: { status: 'success', message: 'Post created successfully' }
  end
  def outbox
    # データ出力
  end
end