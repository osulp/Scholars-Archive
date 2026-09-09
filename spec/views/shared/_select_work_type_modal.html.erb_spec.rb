# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
RSpec.describe 'shared/_select_work_type_modal.html.erb', type: :view do
  let(:presenter) { instance_double Hyrax::SelectTypeListPresenter }
  let(:type_presenters) do
    [
      Hyrax::SelectTypePresenter.new(AdministrativeReportOrPublication),
      Hyrax::SelectTypePresenter.new(Article),
      Hyrax::SelectTypePresenter.new(ConferenceProceedingsOrJournal),
      Hyrax::SelectTypePresenter.new(Dataset),
      Hyrax::SelectTypePresenter.new(ExternalDataset),
      Hyrax::SelectTypePresenter.new(Default),
      Hyrax::SelectTypePresenter.new(EescPublication),
      Hyrax::SelectTypePresenter.new(GraduateProject),
      Hyrax::SelectTypePresenter.new(GraduateThesisOrDissertation),
      Hyrax::SelectTypePresenter.new(HonorsCollegeThesis),
      Hyrax::SelectTypePresenter.new(OpenEducationalResource),
      Hyrax::SelectTypePresenter.new(PurchasedEResource),
      Hyrax::SelectTypePresenter.new(TechnicalReport),
      Hyrax::SelectTypePresenter.new(UndergraduateThesisOrProject)
    ]
  end
  let(:ability) { double(current_user: current_user) }
  let(:current_user) { User.new(email: 'test@example.com', guest: true, api_person_type: api_person_type) }

  before do
    allow(view).to receive(:signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:can?).and_return(true)
    allow(presenter).to receive(:each).and_yield(type_presenters[0]).and_yield(type_presenters[1]).and_yield(type_presenters[2]).and_yield(type_presenters[3]).and_yield(type_presenters[4]).and_yield(type_presenters[5]).and_yield(type_presenters[6]).and_yield(type_presenters[7]).and_yield(type_presenters[8]).and_yield(type_presenters[9]).and_yield(type_presenters[10]).and_yield(type_presenters[11]).and_yield(type_presenters[12]).and_yield(type_presenters[13])
    render 'shared/select_work_type_modal', create_work_presenter: presenter
  end

  context 'as an employee' do
    let(:api_person_type) { 'Employee' }
    let(:work_type_titles) { ['Graduate Students', 'Undergrad Students', 'Faculty Article Deposits', 'Other Scholarly Content', 'Administrator Only'] }

    it 'shows all work types' do
      work_type_titles.each do |title|
        expect(rendered).to have_content(title)
      end
    end
  end

  context 'as a student' do
    let(:api_person_type) { 'Student' }
    let(:work_type_titles) { ['Graduate Students', 'Undergrad Students', 'Other Scholarly Content'] }
    let(:hidden_work_type_titles) { ['Faculty Article Deposits', 'Administrator Only'] }

    it 'shows specific work types' do
      work_type_titles.each do |title|
        expect(rendered).to have_content(title)
      end
    end

    it 'does not show hidden work types' do
      hidden_work_type_titles.each do |title|
        expect(rendered).not_to have_content(title)
      end
    end
  end
end
