# frozen_string_literal: true

describe ScholarsArchive::ParamScrubber do
  let(:scrubber) { described_class }
  let(:scrubbed_param) { scrubber.scrub(params, 'default') }
  let(:params) do
    {
      'default': {
        array: ['    Spaces'],
        hash: {
          id: {
            value: '        Spaces   '
          }.with_indifferent_access
        }.with_indifferent_access,
        single: '         Spaces '
      }.with_indifferent_access
    }.with_indifferent_access
  end

  it { expect(scrubbed_param['default']['single']).to eq 'Spaces' }
  it { expect(scrubbed_param['default']['array'].first).to eq 'Spaces' }
  it { expect(scrubbed_param['default']['hash']['id']['value']).to eq 'Spaces' }
end
