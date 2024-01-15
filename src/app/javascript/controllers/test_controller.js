import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  connect() {
    this.channel = consumer.subscriptions.create("WorldChannel", {
      received(data) {
        console.log(data)
      }
    })
    console.log("Connected to World.", this.channel)
  }
  disconnect() {
    this.channel.unsubscribe()
    console.log("Disconnected from World.", this.channel)
  }
  move(data) {
    this.channel.perform('move', {data: data})
  }
}
