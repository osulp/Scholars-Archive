# frozen_string_literal: true

RSpec.describe 'hyrax/base/_form.html.erb', type: :view do
  let(:ability) { double }
  let(:form) do
    Hyrax::DefaultForm.new(work, ability, controller)
  end
  let(:options_presenter) { double(select_options: []) }
  let(:user) {}

  before do
    allow(Hyrax::AdminSetOptionsPresenter).to receive(:new).and_return(options_presenter)
    stub_template('hyrax/base/_form_progress.html.erb' => 'Progress')
    allow(work).to receive(:new_record?).and_return(true)
    allow(work).to receive(:member_ids).and_return([1, 2])
    allow(view).to receive(:current_user).and_return(user)
    # allow(view).to receive(:curation_concern).and_return(work)
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:current_ability).and_return(ability)
    allow(ability).to receive(:current_user).and_return(user)
    assign(:form, form)
    allow(controller).to receive(:controller_name).and_return('batch_uploads')
    allow(controller).to receive(:action_name).and_return('new')
    # allow(controller).to receive(:repository).and_return(Hyrax::DefaultsController.new.repository)
    # allow(controller).to receive(:blacklight_config).and_return(Hyrax::DefaultsController.new.blacklight_config)
    allow(form).to receive(:permissions).and_return([])
    allow(form).to receive(:visibility).and_return('public')
    stub_template 'hyrax/base/guts4form.html.erb' => 'files'
    stub_template 'hyrax/base/_form_files.html.erb' => 'files'
  end

  context 'with a new object' do
    let(:work) { Default.new }

    context 'with batch_upload on and admin user' do
      let(:user) { instance_double(User, admin?: true, groups: []) }

      before do
        allow(Flipflop).to receive(:batch_upload?).and_return(true)
        render
      end

      it 'shows batch uploads' do
        expect(rendered).to have_link('Batch upload')
      end
    end

    context 'with batch_upload on but non admin user' do
      let(:user) { instance_double(User, admin?: false, groups: []) }

      before do
        allow(Flipflop).to receive(:batch_upload?).and_return(false)
        allow(user).to receive(:admin?).and_return(true)
        render
      end

      it 'hides batch uploads' do
        expect(rendered).not_to have_link('Batch upload')
      end
    end
  end
end
