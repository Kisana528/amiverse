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
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "front",
          "http://192.168.0.4:3001",
          "http://localhost:3001",
          "https://amiverse.net"
        resource "*",
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :head, :options],
          expose: ['X-CSRF-Token'],
          credentials: true
      end
    end

    config.active_job.queue_adapter = :sidekiq
    config.active_record.default_timezone = :local
    config.time_zone = 'Tokyo'
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    I18n.available_locales = [:en, :ja]
  end
end
