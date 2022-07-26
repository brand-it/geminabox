# frozen_string_literal: true

require 'json'
require 'uri'

module Geminabox
  module RubygemsDependency

    class << self

      def for(*gems)
        rubygems_uris.flat_map do |uri, hash|
          url = [
            uri,
            '?gems=',
            gems.map(&:to_s).join(',')
          ].join
          body = Geminabox.http_adapter.get_content(url)
          Marshal.load(body)
        rescue Exception => e
          next [] if Geminabox.allow_remote_failure
          raise e
        end
      end

      def rubygems_uris
        Geminabox.bundler_ruby_gems_urls.map do |url|
          URI.join(url, '/api/v1/dependencies')
        end
      end
    end
  end
end
