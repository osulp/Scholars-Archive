require 'rails_helper'

RSpec.describe HasURIInputType do
  subject { described_class.new(base_input) }
  let(:base_input) { build_base_input }
  let(:object) { build_object }
  let(:options) { Hash.new }

  describe "#options" do
    context "when the field can have multiple values" do
      let(:klass) { build_klass_with_multiples }
      it "should set the input field via :as" do
        expect(subject.options).to eql(options.merge(:as => :uri_multi_value))
      end
    end

    context "when the field cannot have multiple values" do
      let(:klass) { build_klass_without_multiples }
      it "should set the input field via :as" do
        expect(subject.options).to eql(options)
      end
    end
  end

  def build_base_input
    i = instance_double(HydraEditor::Fields::Input)
    allow(i).to receive(:options).and_return(options)
    allow(i).to receive(:object).and_return(object)
    allow(i).to receive(:property).and_return(:property)
    i
  end

  def build_object
    o = double("object")
    allow(o).to receive(:class).and_return(klass)
    o
  end

  def build_klass_with_multiples
    k = double("klass")
    allow(k).to receive(:multiple?).and_return(true)
    k
  end

  def build_klass_without_multiples
    k = double("klass")
    allow(k).to receive(:multiple?).and_return(false)
    k
  end
end
