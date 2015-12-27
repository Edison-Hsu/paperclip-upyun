# require_relative '../../paperclip-upyun/exceptions'
# require_relative '../../paperclip-upyun/response'

module Paperclip
  module Storage
    module Upyun
      def self.extended base
        begin
          require 'upyun'
        rescue LoadError => e
          e.message << " (You may need to install the upyun gem)"
          raise e
        end unless defined?(::Upyun)

        base.instance_eval do
          @bucket = @options[:bucket]
          @operator = @options[:operator]
          @password = @options[:password]

          raise Paperclip::Upyun::Exceptions::OptionsError '(You should set upyun_host)' unless @host = @options[:upyun_host]
          # @options = @options[:options]
          # @endpoint = @options[:endpoint]
          @options[:interval] = "!"

          @upyun = ::Upyun::Rest.new(@bucket, @operator, @password)
          log("@options[:path]: #{@options[:path]}")
          log("@options[:url]: #{@options[:url]}")
          @options[:path]  = @options[:path].gsub(/:url/, @options[:url])
          log("@options[:path]: #{@options[:path]}")
          @options[:url]   = ':upyun_public_url'

          Paperclip.interpolates(:version) do |attachment, style|
            attachment.version(style)
          end unless Paperclip::Interpolations.respond_to? :version

          Paperclip.interpolates(:upyun_public_url) do |attachment, style|
            attachment.public_url(style)
          end unless Paperclip::Interpolations.respond_to? :upyun_public_url

          Paperclip.interpolates :upyun_host  do |attachment, style|
            attachment.upyun_host(style)
          end

        end

      end

      def exists?(style = default_style)
        puts "enter exists? #{style}"
        resp = @upyun.getinfo(path(style))
        begin
          Paperclip::Upyun::Response.parse(resp)
        rescue => err
          log("UPYUN<ERROR>: #{err}")
        end
      end

      def flush_writes
        for style, file in @queued_for_write do
          log("saving #{path(style)}")
          retried = false
          begin
            upload(file, path(style))
          ensure
            file.rewind
          end
        end
        after_flush_writes # allows attachment to clean up temp files
        @queued_for_write = {}
      end

      def flush_deletes
        for path in @queued_for_delete do
          log("deleting: #{path}")
          delete(path)
        end
        @queued_for_delete = []
      end

      def public_url(style = default_style)
        log("url:path=>#{path(style)}")
        url = "#{@options[:upyun_host]}/#{path(style)}"
      end

      def version(style = default_style)
        url = ''
        url += @options[:interval] unless style == default_style
        url += style.to_s unless style == default_style
        url
      end

      def upyun_host(style = default_style)
        "#{@options[:upyun_host]}" || raise('upyun_host is nil')
      end

      private

      def upload(file, path)
        res = @upyun.put(path, File.new(file.path,"rb"))
        begin
          Paperclip::Upyun::Response.parse(res)
        rescue => err
          log("UPYUN<ERROR>: #{err}")
        end
      end

      def delete(path)
        res = @upyun.delete(path)
        begin
          Paperclip::Upyun::Response.parse(res)
        rescue => err
          log("UPYUN<ERROR>: #{err}")
        end
      end
    end
  end
end
