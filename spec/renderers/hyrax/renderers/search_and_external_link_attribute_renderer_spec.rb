require 'rails_helper'

RSpec.describe Hyrax::Renderers::SearchAndExternalLinkAttributeRenderer do
  subject { Nokogiri::HTML(renderer.render) }
  let(:expected) { Nokogiri::HTML(tr_content) }

  describe "#attribute_to_html" do
    let(:field) { :search_and_external_link }
    let(:uri) { "http://test.org/ns/TestSubject/TestLabel" }
    let(:label) { "test label" }
    let(:label_uris) { {'label' => label, 'uri' => uri}}
    let(:linked_label) { "label$uri" }
    let(:label_q) { "test+label" }
    let(:renderer) { described_class.new(field, [label_uris.to_s], search_field: 'academic_affiliation_label') }
    let(:tr_content) do
      %(
      <tr>
      <th>Search and external link</th>
      <td><ul class="tabular"><li class="attribute attribute-search_and_external_link"><a href="/catalog?q=#{label_q}&search_field=academic_affiliation_label">#{label}</a><a aria-label="Open link in new window" class="btn" href="#{uri}" target="_blank"><span class="glyphicon glyphicon-new-window"></span></a></li></ul></td>
      </tr>
      )
    end
    it {
      expect(subject).to be_equivalent_to(expected)
    }

    context "with a URI label" do
      let(:renderer) { described_class.new(field, [linked_label.to_s], search_field: 'based_near_label') }
      let(:linked_label_label) { "label" }
      let(:linked_label_uri) { "uri" }
      let(:expected) { Nokogiri::HTML(tr_content) }
      let(:tr_content) do
        %(
      <tr>
      <th>Search and external link</th>
      <td><ul class="tabular"><li class="attribute attribute-search_and_external_link"><a href="/catalog?q=#{linked_label_label}&search_field=academic_affiliation_label">#{linked_label_label}</a><a aria-label="Open link in new window" class="btn" href="#{linked_label_uri}" target="_blank"><span class="glyphicon glyphicon-new-window"></span></a></li></ul></td>
      </tr>
        )
      end
      it {
        expect(subject).to be_equivalent_to(expected)
      }
    end

    context "with a linked_label" do
      let(:label) { uri }
      let(:label_uris) { uri }
      let(:label_q) { CGI.escape(uri) }
      it {
        expect(subject).to be_equivalent_to(expected)
      }
    end

    context "with a non-URI label" do
      let(:label) { "Bob Ross" }
      let(:label_uris) { label }
      let(:label_q) { "Bob+Ross" }
      let(:tr_content) do
        %(
        <tr>
        <th>Search and external link</th>
        <td><ul class="tabular"><li class="attribute attribute-search_and_external_link"><a href="/catalog?q=#{label_q}&search_field=academic_affiliation_label">#{label}</a></li></ul></td>
        </tr>
        )
      end
      it {
        expect(subject).to be_equivalent_to(expected)
      }
    end
  end
end
