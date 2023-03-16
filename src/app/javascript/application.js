// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@rails/actioncable"
import "channels"
import "account"

let tabToggleTF = false
function tabToggle() {
  tabToggleTF ? document.getElementById('tab').classList.remove('tabbed') : document.getElementById('tab').classList.add('tabbed')
  tabToggleTF = !tabToggleTF
}