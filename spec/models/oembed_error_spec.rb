# frozen_string_literal:true

require 'rails_helper'

RSpec.describe OembedError, type: :model do
  subject { model }

  let(:model) { OembedError.new() }
  let(:error1) { 'ERROR ERROR ERROR' }
  let(:error2) { 'ERROR ERROR ERROR' }

  before do
    model.oembed_errors << error1
    model.oembed_errors << error2
  end

  it { expect(model.oembed_errors).to be_an_instance_of(Array) }
  it { expect(model.oembed_errors.count).to eq(2) }

  it 'prevents error duplication' do
    model.run_callbacks :save
    expect(model.oembed_errors.count).to eq(1)
  end
end
