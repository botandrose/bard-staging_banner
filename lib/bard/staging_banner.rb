require "bard/staging_banner/version"
require "bard/staging_banner/middleware"

module Bard
  module StagingBanner
    class Engine < ::Rails::Engine
      config.app_middleware.use Middleware if Rails.env.staging?
    end
  end
end
