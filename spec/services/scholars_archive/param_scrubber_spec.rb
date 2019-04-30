# frozen_string_literal: true

# Make values in the hash mutable for param scrubber using + operator
describe ScholarsArchive::ParamScrubber do
  let(:scrubber) { described_class }
  let(:scrubbed_param) { scrubber.scrub(params, 'default') }
  let(:params) do
    {
      default: {
        array: [+'    Spaces'],
        hash: ActionController::Parameters.new({
          id: {
            value: +'        Spaces   '
          }.with_indifferent_access
        }.with_indifferent_access),
        single: +'         Spaces '
      }.with_indifferent_access
    }.with_indifferent_access
  end

  it { expect(scrubbed_param['array'].first).to eq 'Spaces' }
  it { expect(scrubbed_param['hash']['id']['value']).to eq 'Spaces' }
  it { expect(scrubbed_param['single']).to eq 'Spaces' }
end
