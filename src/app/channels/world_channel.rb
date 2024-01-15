class WorldChannel < ApplicationCable::Channel
  def subscribed
    stream_from "world_channel"
    # redisで状態管理？
    redis = Redis.new
    redis.sadd("world:players", current_account.account_id)
    # 配信ジョブ発火
  end

  def unsubscribed
    # redisで状態管理？
    redis = Redis.new
    redis.srem("world:players", current_account.account_id)
    # 配信ジョブ削除
  end

  def move(data)
    # 位置やキャラ情報をredisに保存
    Rails.logger.info(data["position"])
    redis = Redis.new
    redis.hset("world:players:" + current_account.account_id, data["position"])
    unless redis.get("world:on")
      WorldJob.perform_later()
    end
    # jobでする内容
    player_ids = redis.smembers("world:players")
    player_data_hash = {}
    player_ids.each do |id|
      player_data = redis.hgetall("world:players:" + id)
      player_data_hash[id] = player_data
    end
    Rails.logger.info("-----------")
    Rails.logger.info(player_data_hash)
  end

  def chat
    # チャット受け取り次第確認し配信
  end
end
