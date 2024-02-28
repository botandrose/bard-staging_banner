module Bard
  module StagingBanner
    class Middleware
      def initialize app
        @app = app
      end

      def call env
        @status, @headers, @body = @app.call(env)
        return [@status, @headers, @body] unless html? && !letter_opener_web?(env)

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

      def letter_opener_web? env
        env["SCRIPT_NAME"].start_with?("/mails")
      end

      def mail_count
        LetterOpenerWeb::Letter.search.length
      end

      def inject response
        count = mail_count
        mail_link = %(<a href="/mails">(#{mail_count})</a>) if count > 0
        html = %(<div class="staging-banner" id="upper-left">Staging #{mail_link}</div>)
        html += %w[upper-right bottom-left bottom-right].map do |corner|
          %(<div class="staging-banner" id="#{corner}"></div>)
        end.join("\n")

        markup = html + <<~CSS
          <style>
            .staging-banner {
              display: flex;
              justify-content: center;
              align-items: flex-end;
              padding: 30px 0 10px;
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
              opacity: 0.75;
            }

            #upper-left {
              top: 0;
              left: 0;
              transform: rotate(-45deg) translate(-52px, -60px);
            }

            #upper-right {
              top: 0;
              right: 0;
              transform: rotate(45deg) translate(52px, -60px);
              pointer-events: none;
            }

            #bottom-left {
              bottom: 0;
              left: 0;
              transform: rotate(225deg) translate(52px, -60px);
              pointer-events: none;
            }

            #bottom-right {
              bottom: 0;
              right: 0;
              transform: rotate(-225deg) translate(-52px, -60px);
              pointer-events: none;
            }
          </style>
        CSS
        response.gsub(%r{</body>}, "#{markup}</body>")
      end
    end
  end
end
