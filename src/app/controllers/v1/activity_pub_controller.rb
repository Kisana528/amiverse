class V1::ActivityPubController < V1::ApplicationController
  include ActivityPub

  def inbox
    # frontで受け取ったactivityを解析・保存
    data = JSON.parse(request.body.read)
    # frontから来たか検証 if data['key'] == ENV['key']
    # digestやsignなど検証 check_sign(data)
    # データ処理
    status = read(data)
    render json: { status: status }
  end
  def outbox
    # データ出力
  end
end