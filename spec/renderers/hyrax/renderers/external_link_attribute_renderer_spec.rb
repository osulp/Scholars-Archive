# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Hyrax::Renderers::ExternalLinkAttributeRenderer do
  let(:field) { :name }
  let(:renderer) { described_class.new(field, ['http://example.com']) }

  describe '#attribute_to_html' do
    subject { Nokogiri::HTML(renderer.render) }

    let(:expected) { Nokogiri::HTML(tr_content) }

    let(:tr_content) do
      "<tr><th>Name</th>\n" \
       "<td><ul class='tabular'>" \
       '<li class="attribute attribute-name">'\
       '<a href="http://example.com">'\
       "http://example.com&nbsp;&nbsp;<span class='glyphicon glyphicon-new-window'></span></a></li>"\
       '</ul></td></tr>'
    end

    it do
      expect(subject).to be_equivalent_to(
        '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
        <html><body><tr><th>Name</th><td><ul class="tabular"><li class="attribute attribute-name">
        <a href="&lt;a%20href=%22http://example.com%22&gt;http://example.com&lt;/a&gt;">http://example.com</a>  <span class="glyphicon glyphicon-new-window"></span>
        </li></ul></td></tr></body></html>'
      )
    end
  end
end
