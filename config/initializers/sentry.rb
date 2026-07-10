if Rails.env.production? && ENV["SENTRY_DSN"].present?
  Sentry.init do |config|
    config.dsn = ENV["SENTRY_DSN"]
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    # Capture 100% of transactions for performance tracing. Lower this if the
    # volume becomes noisy or the Sentry quota gets tight.
    config.traces_sample_rate = 1.0
  end
end
