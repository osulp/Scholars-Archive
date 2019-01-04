# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::Renderers::EdtfAttributeRenderer do
  subject { Nokogiri::HTML(renderer.render) }

  let(:expected) { Nokogiri::HTML(tr_content) }

  describe '#attribute_to_html' do
    let(:field) { :edtf }
    let(:renderer) { described_class.new(field, '2017-06/2017-07', search_field: 'date_created_sim') }
    let(:tr_content) do
      %(
      <tr>
      <th>Edtf</th>
      <td><ul class='tabular'><li class='attribute attribute-edtf'><a href='/catalog?f%5Bdate_created_sim%5D%5B%5D=2017-06%2F2017-07'>2017-06/2017-07</a></li></ul></td>
      </tr>
      )
    end

    it { expect(subject).to be_equivalent_to(expected) }
  end
end
