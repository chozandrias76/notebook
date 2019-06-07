require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Notebook
  class Application < Rails::Application
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{*/}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'services', '{*/}')]
    config.web_console.whitelisted_ips = '25.3.191.86'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Use sidekiq to process jobs
    config.active_job.queue_adapter = :sidekiq

    aws_config = Rails.application.config_for(:aws)
    config.paperclip_defaults = {
      storage: :s3,
      s3_credentials: aws_config,
      bucket: aws_config['s3_bucket_name'],
      preserve_files: true,
      s3_host_name: "s3-#{aws_config["s3_region"]}.amazonaws.com",
      s3_protocol: :https
    }
  end
end
