# frozen_string_literal: true

RSpec.describe 'hyrax/base/_form_progress.html.erb', type: :view do
  let(:user) do
    User.new(username: 'admin', email: 'test@example.com', guest: false)
  end
  let(:form) do
    Hyrax::DefaultForm.new(work, nil, controller)
  end
  let(:work) { Default.new }
  let(:page) do
    view.simple_form_for form do |f|
      render 'hyrax/base/form_progress', f: f
    end
    Capybara::Node::Simple.new(rendered)
  end
  let(:model_name) { 'default' }
  let(:open_option_id) { "##{model_name}_visibility_open" }
  let(:embargo_option_id) { "##{model_name}_visibility_embargo" }
  let(:restricted_option_id) { "##{model_name}_visibility_restricted" }
  let(:authenticated_option_id) { "##{model_name}_visibility_authenticated" }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(work).to receive(:visibility).and_return('open')
    assign(:form, form)
  end

  context 'with visibility options on defaults' do
    context 'when admin users' do
      before do
        allow(user).to receive(:admin?).and_return(true)
      end

      it { expect(page).to have_selector(open_option_id) }
      it { expect(page).to have_selector(embargo_option_id) }
      it { expect(page).to have_selector(restricted_option_id) }
      it { expect(page).to have_selector(authenticated_option_id) }
    end

    context 'when non admin users' do
      before do
        allow(user).to receive(:admin?).and_return(false)
      end

      it { expect(page).to have_selector(open_option_id) }
      it { expect(page).to have_selector(embargo_option_id) }
      it { expect(page).to have_selector(restricted_option_id) }
      it { expect(page).to have_selector(authenticated_option_id) }
    end
  end

  context 'with visibility options on graduate_thesis_or_dissertations' do
    let(:form) do
      Hyrax::GraduateThesisOrDissertationForm.new(work, nil, controller)
    end
    let(:work) { GraduateThesisOrDissertation.new }
    let(:model_name) { 'graduate_thesis_or_dissertation' }

    context 'when for admin users' do
      before do
        allow(user).to receive(:admin?).and_return(true)
      end

      it { expect(page).to have_selector(open_option_id) }
      it { expect(page).to have_selector(embargo_option_id) }
      it { expect(page).to have_selector(restricted_option_id) }
      it { expect(page).to have_selector(authenticated_option_id) }
    end

    context 'when non-admin users' do
      before do
        allow(user).to receive(:admin?).and_return(false)
      end

      it { expect(page).to have_selector(open_option_id) }
      it { expect(page).to have_selector(embargo_option_id) }
      it { expect(page).not_to have_selector(restricted_option_id) }
      it { expect(page).not_to have_selector(authenticated_option_id) }
    end
  end

  context 'with visibility options on graduate_projects' do
    let(:form) do
      Hyrax::GraduateProjectForm.new(work, nil, controller)
    end
    let(:work) { GraduateProject.new }
    let(:model_name) { 'graduate_project' }

    context 'when admin users' do
      before do
        allow(user).to receive(:admin?).and_return(true)
      end

      it { expect(page).to have_selector(open_option_id) }
      it { expect(page).to have_selector(embargo_option_id) }
      it { expect(page).to have_selector(restricted_option_id) }
      it { expect(page).to have_selector(authenticated_option_id) }
    end

    context 'when non-admin users' do
      before do
        allow(user).to receive(:admin?).and_return(false)
      end

      it { expect(page).to have_selector(open_option_id) }
      it { expect(page).to have_selector(embargo_option_id) }
      it { expect(page).not_to have_selector(restricted_option_id) }
      it { expect(page).not_to have_selector(authenticated_option_id) }
    end
  end

  context 'with visibility options on honors_college_thesis' do
    let(:form) do
      Hyrax::HonorsCollegeThesisForm.new(work, nil, controller)
    end
    let(:work) { HonorsCollegeThesis.new }
    let(:model_name) { 'honors_college_thesis' }

    context 'when admin users' do
      before do
        allow(user).to receive(:admin?).and_return(true)
      end

      it { expect(page).to have_selector(open_option_id) }
      it { expect(page).to have_selector(embargo_option_id) }
      it { expect(page).to have_selector(restricted_option_id) }
      it { expect(page).to have_selector(authenticated_option_id) }
    end

    context 'when non-admin users' do
      before do
        allow(user).to receive(:admin?).and_return(false)
      end

      it { expect(page).to have_selector(open_option_id) }
      it { expect(page).to have_selector(embargo_option_id) }
      it { expect(page).not_to have_selector(restricted_option_id) }
      it { expect(page).not_to have_selector(authenticated_option_id) }
    end
  end

  context 'with visibility options on undergraduate_thesis_or_project' do
    let(:form) do
      Hyrax::UndergraduateThesisOrProjectForm.new(work, nil, controller)
    end
    let(:work) { UndergraduateThesisOrProject.new }
    let(:model_name) { 'undergraduate_thesis_or_project' }

    context 'when admin users' do
      before do
        allow(user).to receive(:admin?).and_return(true)
      end

      it { expect(page).to have_selector(open_option_id) }
      it { expect(page).to have_selector(embargo_option_id) }
      it { expect(page).to have_selector(restricted_option_id) }
      it { expect(page).to have_selector(authenticated_option_id) }
    end

    context 'when non-admin users' do
      before do
        allow(user).to receive(:admin?).and_return(false)
      end

      it { expect(page).to have_selector(open_option_id) }
      it { expect(page).to have_selector(embargo_option_id) }
      it { expect(page).not_to have_selector(restricted_option_id) }
      it { expect(page).not_to have_selector(authenticated_option_id) }
    end
  end

  context 'with visibility options for non admin users on articles' do
    let(:form) do
      Hyrax::ArticleForm.new(work, nil, controller)
    end
    let(:work) { Article.new }
    let(:model_name) { 'article' }

    context 'when admin users' do
      before do
        allow(user).to receive(:admin?).and_return(true)
      end

      it { expect(page).to have_selector(open_option_id) }
      it { expect(page).to have_selector(embargo_option_id) }
      it { expect(page).to have_selector(restricted_option_id) }
      it { expect(page).to have_selector(authenticated_option_id) }
    end

    context 'when non admin users' do
      before do
        allow(user).to receive(:admin?).and_return(false)
      end

      it { expect(page).to have_selector(open_option_id) }
      it { expect(page).to have_selector(embargo_option_id) }
      it { expect(page).to have_selector(restricted_option_id) }
      it { expect(page).to have_selector(authenticated_option_id) }
    end
  end
end
