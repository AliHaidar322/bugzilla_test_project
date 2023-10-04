require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Bugzilla
  class Application < Rails::Application
    config.load_defaults 7.0
    config.generators do |g|
      g.factory_bot factory: :factory, dir: 'spec/factories'
    end
  end
end
