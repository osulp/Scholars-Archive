# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::Renderers::ScholarsArchiveNestedAttributeRenderer do
  subject { Nokogiri::HTML(renderer.render) }

  let(:expected) { Nokogiri::HTML(tr_content) }
  let(:label) { 'test label' }

  describe '#attribute_to_html' do
    let(:field) { :sholars_archive_nested }

    context 'render url itemprop' do
      let(:uri) { 'http://test.org/ns/TestSubject/TestLabel' }
      let(:label_uris) { { 'label' => label, 'uri' => uri } }
      let(:label_q) { 'test+label' }
      let(:renderer) { described_class.new(field, [label_uris.to_s], search_field: 'nested_related_items_label_ssim', itemprop_option: 'url') }
      let(:tr_content) do
        %(
      <tr>
      <th>Sholars archive nested</th>
      <td><ul class="tabular"><li class="attribute attribute-sholars_archive_nested">          <span itemprop="relatedLink" itemscope itemtype="http://schema.org/relatedLink">
                  <span itemprop="url">
                    <a href="/catalog?q=#{label_q}&amp;search_field=nested_related_items_label_ssim">#{label}</a><a aria-label="Open link in new window" class="btn" href="#{uri}" target="_blank"><span class="glyphicon glyphicon-new-window"></span></a>
                  </span>
                </span>
      </li></ul></td>
      </tr>
      )
      end

      it {
        expect(subject).to be_equivalent_to(expected)
      }
    end

    context 'render geo itemprop' do
      let(:uri) { 'http://test.org/ns/TestSubject/TestLabel' }
      let(:label_geo) { 'point1 (a,b)' }
      let(:label_geo_q) { 'point1+%28a%2Cb%29' }
      let(:renderer) { described_class.new(field, [label_geo.to_s], search_field: 'nested_geo_label_ssim', itemprop_option: 'geo') }
      let(:tr_content) do
        %(
      <tr>
      <th>Sholars archive nested</th>
      <td><ul class="tabular"><li class="attribute attribute-sholars_archive_nested">          <span itemprop="geo" itemscope itemtype="http://schema.org/GeoCoordinates">
                  <span itemprop="name">
                    <a href="/catalog?f%5Bnested_geo_label_ssim%5D%5B%5D=#{label_geo_q}">#{label_geo}</a>
                  </span>
                </span>
      </li></ul></td>
      </tr>
      )
      end

      it {
        expect(subject).to be_equivalent_to(expected)
      }
    end
  end
end
