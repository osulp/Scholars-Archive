# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScholarsArchive::ExtendedFileBasedAuthority do
  let(:authority) { described_class.new('degree_grantors') }
  let(:terms) do
    [{ 'id' => 'http://id.loc.gov/authorities/names/n95078079',
       'label' => 'Oregon Agricultural College',
       'active' => true,
       'admin_only' => true },
     { 'id' => 'http://id.loc.gov/authorities/names/n87850581',
       'label' => 'Oregon State Agricultural College',
       'active' => true,
       'admin_only' => true },
     { 'id' => 'http://id.loc.gov/authorities/names/n82022628',
       'label' => 'Oregon State College',
       'active' => true,
       'admin_only' => true },
     { 'id' => 'http://id.loc.gov/authorities/names/n80017721',
       'label' => 'Oregon State University',
       'active' => true,
       'admin_only' => false },
     { 'id' => 'Other', 'label' => 'Other', 'active' => true, 'admin_only' => false }]
  end

  describe '#terms' do
    context 'when terms is called' do
      it 'returns an array of the all of the terms' do
        expect(authority.all).to eq terms
        expect(authority.all.map { |t| t[:admin_only] }.count).to eq 5
        expect(authority.all.map { |t| t[:admin_only] }).to include(true)
        expect(authority.all.map { |t| t[:admin_only] }).to include(false)
      end
    end
  end
end
