require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require(*Rails.groups)

module Jasmine
  class Application < Rails::Application
    config.time_zone = 'Beijing'
    config.i18n.default_locale = :'zh-CN'
    config.active_record.raise_in_transactional_callbacks = true
  end
end