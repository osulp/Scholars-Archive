# frozen_string_literal:true

# RSPEC: Create a testing environment to Fixity Mailer class
RSpec.describe ScholarsArchive::FixityMailer do
  # VARIABLES: Create couple variables for testing purpose
  let(:user) { User.new(email: 'test@email.com') }
  let(:tst_data) do
    { start_time: Time.now,
      end_time: Time.now,
      num_file: 21,
      file_pass: 18,
      file_fail: 3,
      fail_arr: %w[1 2 3] }
  end
  let(:mail) { described_class.with(user: user, data: tst_data).report_email }

  # TEST GROUP: Create couple test to see if the mailer class pass the test
  it { expect(mail.subject).to eql('Scholars Archive: Fixity Report') }
  it { expect(mail.to).to eql([user.email]) }
end
