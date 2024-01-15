import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  connect() {
    this.channel = consumer.subscriptions.create("ItemsChannel", {
      received(data) {
        console.log(data)
      }
    })
    console.log("Connected to Hello.", this.channel)
    window.addEventListener('keypress', this.say)
  }
  disconnect() {
    this.channel.unsubscribe()
    console.log("Disconnected from Hello.", this.channel)
    window.removeEventListener('keypress', this.say)
  }
  say(e) {
    console.log("key")
  }
  speak(message) {
    this.channel.perform('speak', {message: message})
  }
}
