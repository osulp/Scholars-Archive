# frozen_string_literal: true

RSpec.describe 'hyrax/my/works/index.html.erb', type: :view do
  let(:resp) { double(docs: '', total_count: 11) }
  let(:user) { instance_double(User, admin?: true) }

  before do
    allow(view).to receive(:current_ability).and_return(ability)
    allow(view).to receive(:provide).and_yield
    allow(view).to receive(:provide).with(:page_title, String)
    assign(:create_work_presenter, presenter)
    assign(:response, resp)
    allow(view).to receive(:can?).and_return(true)
    allow(Flipflop).to receive(:batch_upload?).and_return(batch_enabled)
    stub_template 'shared/_select_work_type_modal.html.erb' => 'modal'
    stub_template 'hyrax/my/works/_tabs.html.erb' => 'tabs'
    stub_template 'hyrax/my/works/_search_header.html.erb' => 'search'
    stub_template 'hyrax/my/works/_document_list.html.erb' => 'list'
    stub_template 'hyrax/my/works/_results_pagination.html.erb' => 'pagination'
    stub_template 'hyrax/my/works/_scripts.js.erb' => 'batch edit stuff'
    assign(:managed_works_count, 1)
    render
  end

  context 'when the current user is an admin' do
    let(:ability) { instance_double(Ability, can_create_any_work?: true, current_user: user) }
    let(:batch_enabled) { true }
    let(:presenter) { instance_double(Hyrax::SelectTypeListPresenter, many?: true) }
    let(:user) { instance_double(User, admin?: true) }

    it 'displays the batch upload link' do
      expect(rendered).to have_link('Create batch of works')
    end
  end

  context 'when the current user isnt an admin' do
    let(:ability) { instance_double(Ability, can_create_any_work?: true, current_user: user) }
    let(:batch_enabled) { true }
    let(:presenter) { instance_double(Hyrax::SelectTypeListPresenter, many?: true) }
    let(:user) { instance_double(User, admin?: false) }

    it 'displays the batch upload link' do
      expect(rendered).not_to have_link('Create batch of works')
    end
  end
end
