// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@rails/actioncable"
import "channels"

console.log("JSのテスト！")

window.onload = () => {
  let tabToggleTF = false
  let themeToggleTF = true
  if(document.getElementById('tab-button')) {
    document.getElementById('tab-button').addEventListener('click', function () {
      tabToggleTF ? document.getElementById('tab').classList.remove('tabbed') : document.getElementById('tab').classList.add('tabbed')
      tabToggleTF = !tabToggleTF
    })
  }
  if(document.getElementById('theme-button')) {
    document.getElementById('theme-button').addEventListener('click', function () {
      themeToggleTF ? document.getElementById('main-container').classList.remove('light-mode') : document.getElementById('main-container').classList.remove('dark-mode')
      themeToggleTF ? document.getElementById('main-container').classList.add('dark-mode') : document.getElementById('main-container').classList.add('light-mode')
      themeToggleTF = !themeToggleTF
    })
  }
}