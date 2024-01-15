class WorldChannel < ApplicationCable::Channel
  def subscribed
    stream_from "world_channel"
    # redisで状態管理？
    redis = Redis.new
    redis.sadd("on_world", current_account.account_id + current_account.name_id)
    # 配信ジョブ発火
  end

  def unsubscribed
    # redisで状態管理？
    redis = Redis.new
    redis.srem("on_world", current_account.account_id + current_account.name_id)
    # 配信ジョブ削除
  end

  def move(data)
    # 位置やキャラ情報をredisに保存
    redis = Redis.new
    # redis.sadd("world_data", {current_account.account_id : data } )
  end

  def chat
    # チャット受け取り次第確認し配信
  end
end
