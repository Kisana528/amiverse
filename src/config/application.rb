require_relative "boot"
require "rails/all"
Bundler.require(*Rails.groups)
module App
  class Application < Rails::Application
    config.load_defaults 7.0
    config.time_zone = 'Tokyo'
    # config.eager_load_paths << Rails.root.join("extras")    
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "front",
          ENV["NEXT_PUBLIC_APPNAME"]
        resource "*",
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :head, :options],
          expose: ['X-CSRF-Token'],
          credentials: true
      end
    end
    config.active_job.queue_adapter = :sidekiq
    config.active_record.default_timezone = :local
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    I18n.available_locales = [:en, :ja]
  end
end
