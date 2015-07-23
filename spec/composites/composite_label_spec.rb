require 'rails_helper'

RSpec.describe CompositeLabel do
  subject { described_class.new(labels) }
  let(:labels) { [label2, label1] }
  let(:label1) { fake_label }
  let(:label2) { fake_label }

  describe "#to_s" do
    it "should choose the first label's to_s" do
      expect(subject.to_s).to eq label2

      expect(label2).to have_received(:to_s)
    end
  end

  def fake_label
    l = double("label")
    allow(l).to receive(:to_s).and_return(l)
    l
  end
end
