require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module VulnerableGems
  class Application < Rails::Application
    config.paperclip_defaults = {
      storage: :s3,
      s3_credentials: {
        bucket: ENV['AWS_BUCKET'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      },
      s3_region: "us-east-1"
    }

    # This app doesn't use ActiveStorage or ActionCable (file uploads go
    # through Paperclip); stop their JS from being auto-added to the asset
    # precompile list. Their modern ES6 syntax breaks Uglifier's ES5-only
    # parser, which otherwise fails `assets:precompile` on unused assets.
    config.active_storage.precompile_assets = false
    config.action_cable.precompile_assets = false

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # load_defaults 5.1 implies cache_format_version 6.1, whose support Rails
    # 7.1 deprecates (removed in 7.2). Bump just this setting ahead of the
    # full load_defaults alignment to silence the warning now.
    config.active_support.cache_format_version = 7.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
