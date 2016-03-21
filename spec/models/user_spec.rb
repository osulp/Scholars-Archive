require 'rails_helper'

RSpec.describe User do
  subject { User.new(:username => 'monkey', :email => email) }
  let(:email) { "valid.email@blah.com" }

  it "should serialize email address on to_s" do
    expect(subject.to_s).to eq(email)
  end

  describe "before_validation on a new User" do
    context "with an invalid email address " do
      let(:email) { '' }
      it "should be set as a unique default email address" do
        subject.save
        expect(subject.email).to eq(subject.default_email)
        expect(subject.has_default_email?).to be(true)
      end
    end
    context "with a valid email address " do
      it "should not set as a unique default email address" do
        subject.save
        expect(subject.email).not_to eq(subject.default_email)
        expect(subject.has_default_email?).to be(false)
      end
    end
  end
end
