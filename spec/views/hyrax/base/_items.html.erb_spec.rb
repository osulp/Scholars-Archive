# frozen_string_literal: true

# OVERRIDE: Override the test to make sure that the <tr> for FileSet has the correct value amount of FileSet upload
RSpec.describe 'hyrax/base/_items.html.erb', type: :view do
  let(:ability) { double }
  let(:request) { double 'request', params: params }
  let(:params) { ActionController::Parameters.new(rows: 10) }

  context 'when children are not present' do
    let(:member_list) { [] }
    let(:file_set_presenters) { double(:file_set_presenters, blank?: true) }
    let(:presenter) { double(:presenter, list_of_items_to_display: member_list, member_presenters_for: member_list, id: 'the-id', human_readable_type: 'Thing', file_set_presenters: file_set_presenters, ext_relation?: false) }

    before do
      expect(presenter).to receive(:list_of_item_ids_to_display).and_return(member_list)
    end

    context 'when the current user can edit the presenter' do
      it 'renders an alert' do
        expect(view).to receive(:can?).with(:edit, presenter.id).and_return(true)
        render 'hyrax/base/items', presenter: presenter
        expect(rendered).to have_css('.alert-warning[role=alert]', text: 'This Thing has no files associated with it. Click "edit" to add more files.')
      end
    end

    context 'when the current user cannot edit the presenter' do
      it 'renders an alert' do
        expect(view).to receive(:can?).with(:edit, presenter.id).and_return(false)
        render 'hyrax/base/items', presenter: presenter
        expect(rendered).to have_css('.alert-warning[role=alert]', text: 'There are no publicly available items in this Thing.')
      end
    end
  end

  context 'when children are present' do
    let(:child1) { double('Thing1', id: 'Thing 1', title: 'Title 1') }
    let(:child2) { double('Thing2', id: 'Thing 2', title: 'Title 2') }
    let(:child3) { double('Thing3', id: 'Thing 3', title: 'Title 3') }
    let(:member_list) { [child1, child2, child3] }
    let(:file_set_presenters) { double(:file_set_presenters, blank?: true) }
    let(:presenter) { double(:presenter, list_of_items_to_display: member_list, member_presenters_for: member_list, id: 'the-id', human_readable_type: 'Thing', file_set_presenters: file_set_presenters, ext_relation?: false) }

    before do
      stub_template 'hyrax/base/_member.html.erb' => '<%= member %>'
      allow(presenter).to receive(:list_of_item_ids_to_display).and_return(member_list)
      allow(presenter).to receive(:member_presenters_for).with(member_list).and_return(member_list)
      allow(presenter).to receive(:ordered_ids).and_return([])
      allow(presenter).to receive(:total_pages).and_return(1)

      allow(ability).to receive(:can?).with(:read, child1.id).and_return true
      allow(ability).to receive(:can?).with(:read, child2.id).and_return false
      allow(ability).to receive(:can?).with(:read, child3.id).and_return true
    end

    it 'displays children' do
      render 'hyrax/base/items', presenter: presenter
      expect(rendered).to have_css('tbody')
    end

    it 'check to see if the <tr> matches the number of fileset object' do
      render 'hyrax/base/items', presenter: presenter
      expect(response.body).to match(/Thing1.*Thing2.*Thing3/m)
    end
  end
end
