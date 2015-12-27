module Paperclip
  module Upyun
    class Response

      def self.parse(res)
        return true if res.is_a?(TrueClass)
        raise TypeError, "Upyun Response type: #{res.class}" unless res.is_a?(Hash)
        self.error(res) if res.has_key?(:error) || res.has_key?("error")
        true
      end

      def self.error(res)
        raise Paperclip::Upyun::Exceptions::ResponseError, "#{res.to_s}"
      end

    end
  end
end
