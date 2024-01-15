import consumer from "channels/consumer"

consumer.subscriptions.create("WorldChannel", {
  connected() {
    console.log('world')
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
  },

  move: function() {
    return this.perform('move');
  },

  chat: function() {
    return this.perform('chat');
  }
});
