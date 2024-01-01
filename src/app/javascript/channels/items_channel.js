import consumer from "channels/consumer"

const appItems = consumer.subscriptions.create("ItemsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('connected : ', this)
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log('disconnected')
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    let div = document.createElement("div")
    div.id = data.item.id
    div.textContent = data.item.content
    document.getElementById('items').appendChild(div)
    return console.log(data['item']['content'])
  },
  speak: function(message) {
    return this.perform('speak', {message: message})
  }
})