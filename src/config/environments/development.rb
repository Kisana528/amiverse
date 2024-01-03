require "active_support/core_ext/integer/time"

Rails.application.configure do
  # falseはactioncableに影響あり
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true
  config.action_controller.perform_caching = true
  config.action_controller.enable_fragment_cache_logging = true
  config.cache_store = :redis_cache_store, {
    url: %w(redis://redis:6379/0), # env
    expires_in: 30.minutes,
    namespace: 'cache',
  }
  ENV["RAILS_SECURE_COOKIES"].present? ? secure_cookies = true : secure_cookies = false
  config.session_store :redis_session_store,
  domain: :all,
  expires: 1.year.from_now,
  secure: secure_cookies,
  httponly: true,
  servers: %w(redis://redis:6379/0), # env
  key: 'ams',
  redis: {
    key_prefix: "session:"
  }
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{2.days.to_i}"
  }
  config.active_storage.service = :minio
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.assets.quiet = true
  # config.i18n.raise_on_missing_translations = true
  # config.action_view.annotate_rendered_view_with_filenames = true
  config.action_cable.disable_request_forgery_protection = true
  config.action_controller.forgery_protection_origin_check = false
  config.hosts << "app"
  config.web_console.allowed_ips = '0.0.0.0/0' # env
end
