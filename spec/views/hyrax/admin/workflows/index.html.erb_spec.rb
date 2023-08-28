# frozen_string_literal: true

RSpec.describe 'hyrax/admin/workflows/index.html.erb', type: :view do
  let(:doc) do
    SolrDocument.new(id: 'abc123',
                     has_model_ssim: ['Default'],
                     date_modified_dtsi: modified_date,
                     title_tesim: ['Submission Title 999'])
  end
  let(:response) { Hyrax::Admin::WorkflowsController::WorkflowResponse.new([doc], 0, 1, 10, nil) }

  let(:modified_date) { 'Wed Apr 24 21:22:44 2019' }

  before do
    assign(:published_list, [doc])
    assign(:response, response)
    render
  end

  context 'when user has submissions to review' do
    it 'displays submission date in the format YYYY-MM-DD HH:MM:SS' do
      expect(rendered).to include('2019-04-24 14:22:44')
    end
  end
end
