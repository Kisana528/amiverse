import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"
export default class extends Controller {
  connect() {
    this.channel = consumer.subscriptions.create("ItemsChannel", {
      received(data) {
        console.log(data)
      }
    })
    console.log("Hello", this.channel)
    window.addEventListener('keypress', this.say)
  }
  disconnect() {
    console.log("Hello??????")
    this.channel.unsubscribe()
    console.log("goodbye", this.channel)
    window.removeEventListener('keypress', this.say)
  }
  say(e) {
    console.log("key")
  }
  speak(e) {
    this.channel.perform('speak', {message: message})
  }
}
