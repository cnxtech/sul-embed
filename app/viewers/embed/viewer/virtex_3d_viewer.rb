# frozen_string_literal: true

module Embed
  module Viewer
    class Virtex3DViewer < CommonViewer
      def to_partial_path
        'embed/template/virtex_3d_viewer'
      end

      def three_dimensional_files
        purl_object.contents.select(&:three_dimensional?).map(&:files).flatten.map(&:title).map do |filename|
          "#{stacks_url}/#{filename}"
        end
      end

      ##
      # Sets the default body height
      def default_body_height
        420
      end

      def self.supported_types
        %i[3d]
      end
    end
  end
end
