module Bard
  module StagingBanner
    class Middleware
      def initialize app
        @app = app
      end

      def call env
        @status, @headers, @body = @app.call(env)
        return [@status, @headers, @body] unless html?

        response = Rack::Response.new([], @status, @headers)
        @body.each do |fragment|
          response.write inject(fragment)
        end
        @body.close if @body.respond_to?(:close)

        response.finish
      end

      private

      def html?
        @headers["Content-Type"] =~ /html/
      end

      def inject response
        markup = <<~HTML
          <div id="staging-banner-top"></div>
          <div id="staging-banner-bottom"></div>
          <style>
            #staging-banner-top:before, #staging-banner-top:after, #staging-banner-bottom:before, #staging-banner-bottom:after {
              display: flex;
              justify-content: center;
              align-items: flex-end;
              padding: 30px 0 10px;
              content: "Staging";
              width: 200px;
              background: yellow;
              color: #0f0f0f;
              position: fixed;
              z-index: 99999;
              font-weight: 900;
              font-size: 1.2em;
              text-transform: uppercase;
              text-align: center;
              box-shadow: 0 1px 4px rgba(0, 0, 0, 0.25);
              transform-origin: 50% 50%;
            }

            #staging-banner-top:before {
              top: 0;
              left: 0;
              transform: rotate(-45deg) translate(-52px, -60px);
            }

            #staging-banner-top:after {
              top: 0;
              right: 0;
              transform: rotate(45deg) translate(52px, -60px);
            }

            #staging-banner-bottom:before {
              bottom: 0;
              left: 0;
              transform: rotate(225deg) translate(52px, -60px);
            }

            #staging-banner-bottom:after {
              bottom: 0;
              right: 0;
              transform: rotate(-225deg) translate(-52px, -60px);
            }
          </style>
        HTML
        response.gsub(%r{</body>}, "#{markup}</body>")
      end
    end
  end
end

