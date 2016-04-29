require 'rails_helper'

describe Embed::MediaTag do
  include PURLFixtures

  let(:purl) { video_purl }
  let(:viewer) do
    double(
      'MediaViewer',
      purl_object: Embed::PURL.new('druid'),
      body_height: '300'
    )
  end
  let(:document) { double('Nokogiri HTML Builder') }
  subject { described_class.new(document, viewer) }

  before { stub_purl_response_with_fixture(purl) }

  describe 'media tags' do
    it 'includes the file label as a data attribute' do
      expect(document).to receive(:video).with(hash_including('data-file-label': 'abc_123.mp4'))
      expect(document).to receive(:video).with(hash_including('data-file-label': 'Second Video'))
      subject
    end

    it 'includes a data attribute for the thumb-slider bar' do
      expect(document).to receive(:video).with(hash_including('data-slider-object': 0))
      expect(document).to receive(:video).with(hash_including('data-slider-object': 1))
      subject
    end

    it 'includes a data-src attribute for the dash player' do
      expect(document).to receive(:video).twice.with(hash_including(:'data-src'))
      subject
    end

    it 'includes a height attribute equal to the body height minus some px to make way for the thumb slider' do
      expect(document).to receive(:video).twice.with(hash_including('height': '276px'))
      subject
    end

    context 'video' do
      it 'renders a video tag in the provided document' do
        expect(document).to receive(:video).at_least(:once)
        subject
      end
    end

    context 'audio' do
      let(:purl) { audio_purl }

      it 'renders an audo tag in the provided document' do
        expect(document).to receive(:audio)
        subject
      end
    end
  end

  describe 'private methods' do
    before { expect(document).to receive(:video).at_least(:once) }
    let(:file) { double('File', title: 'abc123.mp4') }
    describe '#enabled_streaming_sources' do
      it 'adds a source element for every enabled type' do
        expect(document).to receive(:source).with(hash_including(:src, type: 'application/x-mpegURL'))
        subject.send(:enabled_streaming_sources, file)
      end
    end

    describe '#streaming_url_for' do
      it 'appends the generated stream URL with the appropriate suffix' do
        expect(subject.send(:streaming_url_for, file, :hls)).to match(%r{.*/stream.m3u8$})
        expect(subject.send(:streaming_url_for, file, :dash)).to match(%r{.*/stream.mpd$})
      end

      it 'has the appropriate Media Stacks URL with druid and filename' do
        expect(subject.send(:streaming_url_for, file, :hls)).to match(%r{stacks\.stanford\.edu/media/druid/abc123\.mp4/stream.m3u8})
      end
    end
  end
end
