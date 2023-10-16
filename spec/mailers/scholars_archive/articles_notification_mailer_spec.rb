# frozen_string_literal:true

# RSPEC: Create a testing environment to Articles Notification Mailer class
RSpec.describe ScholarsArchive::ArticlesNotificationMailer do
  include ActionView::Helpers::UrlHelper
  # VARIABLES: Create couple variables for testing purpose on mailer
  let(:tst) do
    { title: 'Article Test',
      creator: 'test_depositor',
      dataset_id: 'fe3452',
      link_url: 'https://test.com/' }
  end
  let(:mail) { described_class.with(data: tst).email_article_depositor }

  # TEST GROUP #1: Create a test to see if the mailer class pass the test on subject heading
  it { expect(mail.subject).to eql('[Scholars Archive] - Article Deposit Notice') }

  # TEST GROUP #2: Create couple test to see if the view mailer hold the exact same data
  it { expect(mail.body.encoded).to include("Article's Title - #{tst[:title]}") }
  it { expect(mail.body.encoded).to include("Article's ID - #{tst[:article_id]}") }
  it { expect(mail.body.encoded).to include("Depositor - #{tst[:creator]}") }
  it { expect(mail.body.encoded).to include("pURL: #{tst[:link_url]}") }
end
