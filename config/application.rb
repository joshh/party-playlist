require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SpotifyJukebok
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.eager_load_paths << Rails.root.join('lib')
    config.assets.precompile += %w( *.js *.css )
    config.assets.compile = true
    config.serve_static_assets = true
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.


    Spring.watch "app/services/**"

    Bundler.require(*Rails.groups)
    Dotenv::Railtie.load
  end
end
