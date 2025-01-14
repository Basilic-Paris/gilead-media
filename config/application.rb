require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GileadMedia
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # ADDED
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.generators do |generate|
      generate.assets false
      generate.helper false
      # generate.test_framework :test_unit, fixture: false
      generate.test_framework :rspec,
                              view_specs: false,
                              helper_specs: false,
                              routing_specs: false,
                              controller_specs: false
    end
    config.time_zone = 'Europe/Paris'
    config.i18n.default_locale = :fr
    config.i18n.available_locales = [:fr]
    config.action_mailer.default_options = {
      from: '"mail Gilead" <envoi@giledia.com>'
    }
    config.active_record.default_timezone = :local
    config.cache_classes = true
    # ADDED
  end
end
