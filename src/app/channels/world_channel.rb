class WorldChannel < ApplicationCable::Channel
  def subscribed
    stream_from "world_channel"
    redis = Redis.new
    redis.sadd("world:players", current_account.aid)
    #unless redis.get("world:on")
    #  WorldJob.perform_later()
    #end
    player_ids_array = redis.smembers("world:players")
    world_data_hash = {}
    world_data_hash['player_ids'] = player_ids_array
    ActionCable.server.broadcast('world_channel', world_data_hash)
  end

  def unsubscribed
    redis = Redis.new
    redis.srem("world:players", current_account.aid)
    world_data_hash = {}
    player_ids_array = redis.smembers("world:players")
    world_data_hash['player_ids'] = player_ids_array
    ActionCable.server.broadcast('world_channel', world_data_hash)
  end

  def move(data)
    #redis = Redis.new
    #redis.hset("world:players:" + current_account.aid, data["position"])
    player_data_hash = {}
    player_data_hash[current_account.aid] = data["position"]
    world_data_hash = {}
    world_data_hash['players'] = player_data_hash
    ActionCable.server.broadcast('world_channel', world_data_hash)
  end

  def chat
    # チャット受け取り次第確認し配信
  end
end
