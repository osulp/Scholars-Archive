# frozen_string_literal:true

# RSPEC: Create a testing environment to Fixity Mailer class
RSpec.describe ScholarsArchive::HumanDataMailer do
  include ActionView::Helpers::UrlHelper
  # VARIABLES: Create couple variables for testing purpose
  let(:user) { User.new(email: 'test@email.com') }
  let(:tst) do
    { title: 'Dataset Test',
      creator: 'test_depositor',
      dataset_id: '23de3221',
      link_url: 'https://test.com/' }
  end
  let(:mail) { described_class.with(user: user, data: tst).email_on_human_data }

  # TEST GROUP #1: Create couple test to see if the mailer class pass the test
  it { expect(mail.subject).to eql('Dataset Alert! Human Subject Data Included') }
  it { expect(mail.to).to eql([user.email]) }

  # TEST GROUP #2: Create couple test to see if the view mailer hold the exact same data
  it { expect(mail.body.encoded).to include("Dataset Title: #{tst[:title]}") }
  it { expect(mail.body.encoded).to include("Dataset ID & Link to Dataset: #{link_to tst[:dataset_id], tst[:link_url]}") }
  it { expect(mail.body.encoded).to include("Depositor: #{tst[:creator]}") }
end
