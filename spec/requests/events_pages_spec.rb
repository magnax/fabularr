# frozen_string_literal: true

require 'spec_helper'

describe 'Events', type: :feature do

	subject { page }

	let!(:fabular_city) { create(:location, name: 'Fabular City') }
	let!(:other_city) { create(:location, name: 'Other City') }
	let(:user) { create(:user) }

	describe 'for non signed-in users' do
		before { visit events_path }

    it { should have_content('Fabular login') }
	end

	describe 'for signed-in users' do

		before { sign_in user }

		describe 'should return to list without character set' do
			before { visit events_path }

	    it { should have_content("Hello #{user.email}") }
		end

		describe 'for signed-in users, and with character set' do

			let!(:magnus) { create(:character, name: 'Magnus', location: fabular_city, user: user) }
			let!(:ella) { create(:character, name: 'Ella', gender: 'K', location: fabular_city, user: user) }
			let!(:sid) { create(:character, name: 'Sid', location: other_city, user: user) }
			
			describe 'should have events for character' do
				before do
					visit list_path
					click_link 'Magnus'
				end
				
				it { should have_content('Events for: Magnus') }
				it { should have_content('Location: Fabular City') }
				it { should have_link('Magnus') }
				it { should have_link('unknown woman') }
				it { should_not have_link('Sid') }
			end
		end
	end
end
