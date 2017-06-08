require 'rails_helper'

RSpec.describe Hyrax::Renderers::LanguageAttributeRenderer do
  let(:field) { :language }
  let(:renderer) { described_class.new(field, ['http://id.loc.gov/vocabulary/iso639-2/tib', 'http://id.loc.gov/vocabulary/iso639-2/tlh']) }

  describe '#attribute_to_html' do
    subject { Nokogiri::HTML(renderer.render) }
    let(:expected) { Nokogiri::HTML(tr_content) }

    let(:tr_content) do
      "<tr><th>Language</th>\n" \
       "<td><ul class='tabular'>\n" \
       "<li class=\"attribute language\"><a href=\"http://id.loc.gov/vocabulary/iso639-2/tib\" target=\"_blank\">Tibetan [tib]</a></li>\n" \
       "<li class=\"attribute language\"><a href=\"http://id.loc.gov/vocabulary/iso639-2/tlh\" target=\"_blank\">Klingon; tlhIngan-Hol [tlh]</a></li>\n" \
       '</ul></td></tr>'
    end
    it { expect(subject).to be_equivalent_to(expected) }
  end
end
