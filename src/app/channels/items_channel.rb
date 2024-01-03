class ItemsChannel < ApplicationCable::Channel
  include SessionsHelper
  def subscribed
    stream_from "items_channel"
    Rails.logger.info(current_account.name_id)
  end

  def unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast('items_channel', data)
  end
end
