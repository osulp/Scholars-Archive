# frozen_string_literal: true

require 'spec_helper'

describe WorkflowsIndexHelper do
  describe '#local_time_from_utc' do
    let(:date_modified_utc) { '2019-06-07T15:23:16Z' }

    it 'returns local time in Y-m-d H:M:S format' do
      expect(helper.local_time_from_utc(date_modified_utc)).to eq '2019-06-07 08:23:16'
    end
  end
end
