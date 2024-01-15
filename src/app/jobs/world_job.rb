class WorldJob < ApplicationJob
  queue_as :default

  def perform()
    redis = Redis.new
    if redis.setnx("world:on", "true")
      loop do
        break if redis.scard("world:players") == 0
        player_ids = redis.smembers("world:players")
        player_data_hash = {}
        player_ids.each do |id|
          player_data = redis.hgetall("world:players:" + id)
          player_data_hash[id] = player_data
        end
        Rails.logger.info('Deliver world data.')
        ActionCable.server.broadcast('world_channel', player_data_hash)
        sleep 5.second
      end
      redis.del("world:on")
    end
  end
end