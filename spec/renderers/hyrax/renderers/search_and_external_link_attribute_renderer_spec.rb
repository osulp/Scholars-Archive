require 'rails_helper'

RSpec.describe Hyrax::Renderers::SearchAndExternalLinkAttributeRenderer do
  subject { Nokogiri::HTML(renderer.render) }
  let(:expected) { Nokogiri::HTML(tr_content) }

  describe "#attribute_to_html" do
    let(:field) { :search_and_external_link }
    let(:uri) { "http://test.org/ns/TestSubject/TestLabel" }
    let(:label) { "test label" }
    let(:label_uris) { {'label' => label, 'uri' => uri}}
    let(:label_q) { "test+label" }
    let(:renderer) { described_class.new(field, [label_uris.to_s], search_field: 'academic_affiliation_label') }
    let(:tr_content) do
      %(
      <tr>
      <th>Search and external link</th>
      <td><ul class="tabular"><li class="attribute search_and_external_link"><a href="/catalog?q=#{label_q}&search_field=academic_affiliation_label">#{label}</a><a aria-label="Open link in new window" class="btn" href="#{uri}"><span class="glyphicon glyphicon-new-window"></span></a></li></ul></td>
      </tr>
      )
    end
    it {
      expect(subject).to be_equivalent_to(expected)
    }
  end
end
