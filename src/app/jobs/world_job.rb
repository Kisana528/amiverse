class WorldJob < ApplicationJob
  queue_as :default

  def perform()
    redis = Redis.new
    if redis.setnx("world:on", "true")
      loop do
        break if redis.scard("world:players") == 0
        player_ids_array = redis.smembers("world:players")
        player_data_hash = {}
        player_ids_array.each do |id|
          player_data = redis.hgetall("world:players:" + id)
          player_data_hash[id] = player_data
        end
        world_data_hash = {}
        world_data_hash['player_ids'] = player_ids_array
        world_data_hash['players'] = player_data_hash
        Rails.logger.info("------------------")
        ActionCable.server.broadcast('world_channel', world_data_hash)

        if Rails.env.production?
          sleep(0.1)
        else
          sleep(3)
        end
      end
      redis.del("world:on")
    end
  end
end