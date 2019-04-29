# frozen_string_literal: true

describe ScholarsArchive::ParamScrubber do
  let(:scrubber) { described_class }
  let(:params) do  
    {'default': { array: ['    Spaces'], 
                  hash: { id: { value: '        Spaces   ' }.with_indifferent_access }.with_indifferent_access,
                  single: '         Spaces ' 
                }.with_indifferent_access
    }.with_indifferent_access
  end
  it { expect(scrubber.scrub(params, 'default')['default']['single']).to eq 'Spaces' }
  it { expect(scrubber.scrub(params, 'default')['default']['array'].first).to eq 'Spaces' }
  it { expect(scrubber.scrub(params, 'default')['default']['hash']['id']['value']).to eq 'Spaces' }
end
