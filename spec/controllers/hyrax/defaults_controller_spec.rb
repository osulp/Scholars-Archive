# frozen_string_literal:true

RSpec.describe Hyrax::DefaultsController do
  # TEST NO.1: To see if the env was able to set the param into the form
  describe '#attributes_for_actor' do
    let(:url) { 'https://www.test.com' }

    context 'when an ext_relation is set in the params' do
      it 'adds the url to the actor environment' do
        controller.params = ActionController::Parameters.new({ ext_relation: [url] })
        expect(controller.attributes_for_actor[:ext_relation]).to eq [url]
      end
    end
  end
end
