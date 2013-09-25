require 'globals'

def preprocess(file)
  output = File.expand_path("../#{file}", __FILE__)
  input = File.expand_path("../support/#{file}", __FILE__)

  unless File.exists?(output) && File.mtime(output) >= File.mtime(input)
    puts "Generating #{output}."
    File.open(output, 'w') do |f|
      f.write ERB.new(File.read input).result
    end
  end

  output
end

$user = ENV["USER"].split(".").first
$globals = Globals.read preprocess('globals.yml')
preprocess('database.yml')

require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

Product = Object.module_eval("module #{$globals.application}; end; #{$globals.application}")

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Product
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.railties_order = [UserAuthentication::Engine, :main_app, :all]

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root})
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    config.active_record.observers = Dir["#{config.root}/app/observers/*"].map { |f| File.basename f, File.extname(f) }
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.generators do |g|
      g.template_engine :haml
    end

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = "1.0"

    # Your secret key for verifying the integrity of signed cookies.
    # If you change this key, all old signed cookies will become invalid!
    # Make sure the secret is at least 30 characters and all random,
    # no regular words or you'll be exposed to dictionary attacks.
    config.secret_token = $globals.token
    config.session_store :cookie_store, :key => "session"
  end
end
