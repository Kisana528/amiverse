Rails.application.config.active_storage.resolve_model_to_route = :rails_storage_proxy
Rails.application.config.active_storage.routes_prefix = '/items'
Rails.application.config.active_storage.variant_processor = :mini_magick