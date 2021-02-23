# frozen_string_literal: true

# Make values in the hash mutable for param scrubber using + operator
describe ScholarsArchive::ParamScrubber do
  let(:scrubber) { described_class }
  let(:scrubbed_param) { scrubber.scrub(params, 'default') }
  let(:scrubbed_ed2_param) { scrubber.scrub(ed2_params, 'default') }
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
  let(:ed2_params) do
    {
      default: {
        array_hash: [ActionController::Parameters.new({ value: +'        Spaces   ' }.with_indifferent_access)]
      }.with_indifferent_access
    }.with_indifferent_access
  end

  it { expect(scrubbed_param['array'].first).to eq 'Spaces' }
  it { expect(scrubbed_param['hash']['id']['value']).to eq 'Spaces' }
  it { expect(scrubbed_param['single']).to eq 'Spaces' }
  it { expect(scrubbed_ed2_param['array_hash'].first['value']).to eq 'Spaces' }
end
