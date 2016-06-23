# rubocop:disable Lint/HandleExceptions
module ActionView
  module Helpers
    module UrlHelper
      # Back-ported from Rails 5. We have had to port this update in order to close a XSS
      # vulnerability with the use of the http referer. This can be changed on the client side
      # and used as a means to inject malicious code into a page, for example in the case where
      # you specify the link value to just be the return result of :back. This closes that
      # hole.
      # See https://github.com/rails/rails/pull/22180 and
      # https://github.com/rails/rails/blob/e8b2c0535c203119e6733a982dc22734f3da1219/\
      # actionview/lib/action_view/helpers/url_helper.rb
      # for details.
      def _back_url
        _filtered_referrer || "javascript:history.back()"
      end
      protected :_back_url

      def _filtered_referrer
        if controller.respond_to?(:request)
          referrer = controller.request.env["HTTP_REFERER"]
          referrer if referrer && URI(referrer).scheme != "javascript"
        end
      rescue URI::InvalidURIError
      end
      protected :_filtered_referrer
    end
  end
end
