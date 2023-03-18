require "bard/staging_banner/version"
require "bard/staging_banner/middleware"

module Bard
  module StagingBanner
    class Engine < ::Rails::Engine
      if Rails.env.staging?
        config.app_middleware.use Middleware
      end

      if !Rails.env.production? && defined?(ActionMailer)
        initializer "bard-staging_banner.mount_letter_opener_web" do |app|
          require "letter_opener_web"

          config.action_mailer.delivery_method = :letter_opener

          app.routes.append do
            mount LetterOpenerWeb::Engine, at: "/mails"
          end
        end
      end
    end
  end
end
