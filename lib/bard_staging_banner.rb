require "bard_staging_banner/version"
require "bard_staging_banner/middleware"

module BardStagingBanner
  class Engine < ::Rails::Engine
    config.app_middleware.use Middleware if Rails.env.staging?
  end
end
