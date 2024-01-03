class WorldChannel < ApplicationCable::Channel
  def subscribed
    stream_from "world_channel"
    # redisで状態管理？
    redis = Redis.new
    redis.set("on_world", 1)
    # 配信ジョブ発火
  end

  def unsubscribed
    # redisで状態管理？
    redis = Redis.new
    redis.set("on_world", 0)
    # 配信ジョブ削除
  end

  def move
    # 位置やキャラ情報をredisに保存
  end

  def chat
    # チャット受け取り次第確認し配信
  end
end
