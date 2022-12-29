require "bard/staging_banner/version"
require "bard/staging_banner/middleware"
require "letter_opener_web"

module Bard
  module StagingBanner
    class Engine < ::Rails::Engine
      if Rails.env.staging?
        config.app_middleware.use Middleware
      end

      if !Rails.env.production?
        config.action_mailer.delivery_method = :letter_opener
        initializer "bard-staging_banner.mount_letter_opener_web" do |app|
          app.routes.append do
            mount LetterOpenerWeb::Engine, at: "/mails"
          end
        end
      end
    end
  end
end
