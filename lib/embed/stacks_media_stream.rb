# frozen_string_literal: true

##
# Construct the urls to the streaming
# server for a given file w/i an object
module Embed
  class StacksMediaStream
    TYPE_TO_MANIFEST_FILE = {
      hls: '/playlist.m3u8',
      flash: '',
      dash: '/manifest.mpd'
    }.freeze

    def initialize(druid:, file_name:)
      @druid = druid
      @file_name = file_name
    end

    def to_playlist_url
      streaming_url_for(:hls)
    end

    def to_rtmp_url
      streaming_url_for(:flash)
    end

    def to_manifest_url
      streaming_url_for(:dash)
    end

    private

    attr_reader :druid, :file_name

    def streaming_url_for(type)
      return unless file_name && streaming_file_prefix

      protocol = streaming_protocol(type)
      suffix = TYPE_TO_MANIFEST_FILE[type]
      delimiter = streaming_url_delimiter(type)
      "#{protocol}://#{streaming_base_url}#{delimiter}#{druid_tree}/#{streaming_url_file_segment}#{suffix}"
    end

    def streaming_url_delimiter(type)
      return '&' if type == :flash

      '/'
    end

    def streaming_file_prefix
      Settings.streaming_prefix[file_extension]
    end

    def video?
      Settings.stream.video.include? file_extension
    end

    def audio?
      Settings.stream.audio.include? file_extension
    end

    def file_extension
      ::File.extname(file_name).delete('.')
    end

    def streaming_base_url
      Settings.stream.url
    end

    def druid_tree
      @druid_tree ||= begin
        match = druid.match(/^([a-z]{2})(\d{3})([a-z]{2})(\d{4})$/i)
        File.join(match[1], match[2], match[3], match[4]) if match
      end
    end

    def streaming_url_file_segment
      "#{streaming_file_prefix}:#{file_name}"
    end

    def streaming_protocol(type)
      Settings.streaming[type].protocol
    end
  end
end
