class WorldJob < ApplicationJob
  queue_as :default

  def perform()
    loop do
      redis = Redis.new
      break if redis.scard("on_world") == 0
      # 配信
      # redisからデータ取り出す
      # data = ?
      # ActionCable.server.broadcast('items_channel', data)

      sleep 1.second
    end
  end