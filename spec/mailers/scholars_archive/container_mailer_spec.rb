# frozen_string_literal:true

# RSPEC: Create a testing environment to Container Mailer class
RSpec.describe ScholarsArchive::ContainerMailer do
  # VARIABLES: Create couple variables for testing purpose
  let(:email) { 'test@email.com' }

  let(:mail) { described_class.with(to: email).report_email }

  # TEST GROUP #1: Create couple test to see if the mailer class pass the test
  it { expect(mail.subject).to eql('Scholars Archive: Archive/Container Files Inventory Report') }
  it { expect(mail.body.encoded).to include("The report on the Filesets Inventory of container/archive files is attached.") }
  it { expect(mail.to).to eql([email]) }
end
