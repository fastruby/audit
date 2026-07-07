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
    config.load_defaults 7.1

    # On Rails 8.0 (the current boot) this opts `to_time` into preserving the full
    # timezone -- without it, 8.0 warns that the behavior changes in 8.1. Rails 8.1
    # makes that the default and *deprecates* the setter (no-op shim), so skip it on
    # the `next?` boot to keep 8.1 warning-free. Removed outright at cutover.
    config.active_support.to_time_preserves_timezone = :zone unless NextRails.next?

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
