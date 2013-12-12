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
        markup = %(<div id="staging-banner" style="background: yellow; color: black; position: fixed; bottom: 0; left: 0; width: 100%; font: bold 16pt Arial; line-height: 1.5em; text-align: center; z-index: 999;">You are on the Staging Site</div>)
        response.gsub(%r{</body>}, "#{markup}</body>")
      end
    end
  end
end

