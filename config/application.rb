require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GileadMedia
  class Application < Rails::Application
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
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.time_zone = 'Europe/Paris'
    config.i18n.default_locale = :fr
    config.i18n.available_locales = [:fr]
    config.action_mailer.default_options = {
      from: '"mail Gilead" <envoi@giledia.com>'
    }
  end
end
