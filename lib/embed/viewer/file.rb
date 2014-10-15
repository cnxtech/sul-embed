module Embed
  class Viewer
    class File
      include Embed::Viewer::CommonViewer

      def initialize(*args)
        super
        header_tools_logic << :file_search_logic
      end

      def self.default_viewer?
        true
      end

      def height
        '300'
      end

      def width
        '300'
      end

      def body_html
        file_count = 0
        Nokogiri::HTML::Builder.new do |doc|
          doc.div(class: 'sul-embed-body sul-embed-file', 'data-sul-embed-theme' => "#{asset_url('file.css')}") do
            doc.div(class: 'sul-embed-file-list') do
              doc.ul(class: 'sul-embed-media-list') do
                @purl_object.contents.each do |resource|
                  resource.files.each do |file|
                    doc.li(class: 'sul-embed-media') do
                      doc.div(class: 'sul-embed-count pull-left') do
                        doc.text file_count += 1
                      end
                      doc.div(class: 'sul-embed-media-object pull-left') do
                        doc.i(class: "fa fa-3x #{file_type_icon(file.mimetype)}")
                      end
                      doc.div(class: 'sul-embed-media-body') do
                        doc.div(class: 'sul-embed-media-heading') do
                          doc.a(href: file_url(file.title)) do
                            doc.text file.title
                          end
                        end
                        doc.div(class: 'sul-embed-description') do
                          doc.text resource.description
                        end
                        doc.div(class: 'sul-embed-download') do
                          doc.i(class: 'fa fa-download')
                          doc.a(href: file_url(file.title), download: nil) do
                            doc.text pretty_filesize(file.size)
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
            doc.script { doc.text ";jQuery.getScript(\"#{asset_url('file.js')}\");" }
          end
        end.to_html
      end

      def file_type_icon(mimetype)
        if Constants::FILE_ICON[mimetype].nil?
          'fa-file-o'
        else
          Constants::FILE_ICON[mimetype]
        end
      end

      def pretty_filesize(size)
        Filesize.from("#{size} B").pretty
      end

      def file_url(title)
        "#{stacks_url}/#{title}"
      end

      def self.supported_types
        [:media]
      end

      private

      def file_search_logic
        return false if @request.params[:hide_search] && @request.params[:hide_search] == 'true'
        :file_search_html
      end

      def file_search_html(doc)
        doc.div(class: 'sul-embed-header-tools') do
          doc.div(class: 'sul-embed-search') do
            doc.label(for: 'sul-embed-search-input') { doc.text 'Search this list' }
            doc.input(class: 'sul-embed-search-input', id: 'sul-embed-search-input')
          end
        end
      end
    end
  end
end

Embed.register_viewer(Embed::Viewer::File) if Embed.respond_to?(:register_viewer)
