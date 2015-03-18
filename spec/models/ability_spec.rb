require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject { described_class.new(user) }
  context "a user with no roles" do
    let(:user) { }
    it { is_expected.not_to be_able_to(:create, GenericFile) }
    it { is_expected.not_to be_able_to(:create, Collection) }
    it { is_expected.not_to be_able_to(:view_share_work, GenericFile) }
  end
  context "a logged in user" do
    let(:user) do
      u = User.new
      allow(u).to receive(:groups).and_return(["registered"])
      u
    end
    it { is_expected.not_to be_able_to(:create, GenericFile) }
    it { is_expected.not_to be_able_to(:create, Collection) }
    it { is_expected.not_to be_able_to(:view_share_work, GenericFile) }
  end
  context "an admin" do
    let(:user) do
      u = User.new
      allow(u).to receive(:groups).and_return(["registered", "admin"])
      u
    end
    it { is_expected.to be_able_to(:create, GenericFile) }
    it { is_expected.to be_able_to(:create, Collection) }
    it { is_expected.to be_able_to(:view_share_work, GenericFile) }
  end
end
