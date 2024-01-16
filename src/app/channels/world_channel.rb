class WorldChannel < ApplicationCable::Channel
  def subscribed
    stream_from "world_channel"
    redis = Redis.new
    redis.sadd("world:players", current_account.account_id)
    unless redis.get("world:on")
      WorldJob.perform_later()
    end
  end

  def unsubscribed
    redis = Redis.new
    redis.srem("world:players", current_account.account_id)
  end

  def move(data)
    redis = Redis.new
    redis.hset("world:players:" + current_account.account_id, data["position"])
  end

  def chat
    # チャット受け取り次第確認し配信
  end
end
