require 'rails_helper'

RSpec.describe ScholarsArchive::URIEnabledStringField do
  subject { described_class.new(builder, :attribute, options) }
  let(:builder) { build_builder }
  let(:options) { {:name => "name", :id => "id", :value => value } }

  describe "#field" do
    context "when the value is RDF" do
      let(:value) { build_rdf_value }

      it "should create a read-only, nameless, id-less text field with the label" do
        expected_opts = {:name => nil, :id => nil, :value => "Label", :readonly => true}
        expect(builder).to receive(:text_field).with(:attribute, expected_opts)
        subject.field
      end

      it "should create a submitable, read-only field with the URI" do
        expected_opts = {
          :name => "name",
          :id => "id",
          :value => "http://rdf.example.com",
          :readonly => true,
          :class => ["hidden"]
        }
        expect(builder).to receive(:text_field).with(:attribute, expected_opts)
        subject.field
      end

      it "should return both fields" do
        expect(subject.field).to eq("text field HTMLtext field HTML")
      end
    end

    context "when the value isn't RDF" do
      let(:value) { build_non_rdf_value }

      it "should create a text field with the options left alone" do
        expect(builder).to receive(:text_field).with(:attribute, options)
        subject.field
      end
    end
  end

  def build_builder
    b = instance_double(ActionView::Helpers::FormBuilder)
    allow(b).to receive(:text_field).and_return("text field HTML")
    b
  end

  def build_rdf_value
    v = instance_double(ActiveTriples::Resource)
    allow(v).to receive(:rdf_label).and_return(["Label"])
    allow(v).to receive(:rdf_subject).and_return(RDF::URI("http://rdf.example.com"))
    v
  end

  def build_non_rdf_value
    "Some text"
  end
end
