# frozen_string_literal: true

require 'spec_helper'

describe 'Events', type: :feature do
  subject { page }

  let!(:fabular_city) { create(:location, name: 'Fabular City') }
  let!(:other_city) { create(:location, name: 'Other City') }
  let(:user) { create(:user) }

  describe 'for non signed-in users' do
    before { visit events_path }

    it { is_expected.to have_content('Fabular login') }
  end

  describe 'for signed-in users' do
    before { sign_in user }

    describe 'should return to list without character set' do
      before { visit events_path }

      it { is_expected.to have_content("Hello #{user.email}") }
    end

    describe 'for signed-in users, and with character set' do
      describe 'should have events for character' do
        before do
          create(:character, name: 'Magnus', location: fabular_city, user: user)
          create(:character, name: 'Ella', gender: 'K', location: fabular_city, user: user)
          create(:character, name: 'Sid', location: other_city, user: user)
          visit list_path
          click_link 'Magnus'
        end

        it { is_expected.to have_content('Events for: Magnus') }
        it { is_expected.to have_content('Location: Fabular City') }
        it { is_expected.to have_link('Magnus') }
        it { is_expected.to have_link('unknown woman') }
        it { is_expected.not_to have_link('Sid') }
        it { is_expected.to have_content('Resources') }
        it { is_expected.to have_content('Items') }
        it { is_expected.to have_content('Projects') }
        it { is_expected.to have_link('Discover new resource') }
      end
    end

    describe 'should have events for character' do
      let!(:lr) do
        create(:location_resource, location: fabular_city,
                                   resource: create(:resource, key: 'mushrooms'))
      end

      before do
        create(:character, name: 'Magnus', location: fabular_city, user: user)
        visit list_path
        click_link 'Magnus'
      end

      it { is_expected.to have_content('Mushrooms') }
      it { is_expected.to have_link('Collect', href: "http://www.example.com/projects/new/collect/#{lr.id}") }
    end
  end
end
