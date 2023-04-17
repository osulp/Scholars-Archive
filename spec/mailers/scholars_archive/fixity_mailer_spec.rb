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
      fail_arr: %w[nk322d 3t94fn 0r489m] }
  end
  let(:mail) { described_class.with(user: user, data: tst_data).report_email }

  # TEST GROUP #1: Create couple test to see if the mailer class pass the test
  it { expect(mail.subject).to eql('Scholars Archive: Fixity Report') }
  it { expect(mail.to).to eql([user.email]) }

  # TEST GROUP #2: Create couple test to see if the view mailer hold the exact same data
  it { expect(mail.body.encoded).to include("Start Time: #{tst_data[:start_time]}") }
  it { expect(mail.body.encoded).to include("End Time: #{tst_data[:end_time]}") }
  it { expect(mail.body.encoded).to include("No. of Files [CHECKED]: #{tst_data[:num_file]}") }
  it { expect(mail.body.encoded).to include("No. of Files [PASSED]: #{tst_data[:file_pass]}") }
  it { expect(mail.body.encoded).to include("No. of Files [FAILED]: #{tst_data[:file_fail]}") }

  it 'looking to match each fail index pass through params' do
    tst_data[:fail_arr].each do |f_id|
      expect(mail.body.encoded).to include(f_id.to_s)
    end
  end
end
