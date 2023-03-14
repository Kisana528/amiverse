require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    ENV["RAILS_SECURE_COOKIES"].present? ? secure_cookies = true : secure_cookies = false
    config.session_store :cookie_store, key: 'amiverse_ses',
      domain: :all,
      expires: 1.year.from_now,
      secure: secure_cookies,
      httponly: true
    
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "front",
          "http://localhost:3001",
          "https://amiverse.net"
        resource "*",
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :head, :options],
          expose: ['X-CSRF-Token'],
          credentials: true
      end
    end
  end
end
