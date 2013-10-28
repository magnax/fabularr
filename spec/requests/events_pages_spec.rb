#encoding = utf-8
require 'spec_helper'

describe "Events" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	let!(:fabular_city) { Location.new(name: "Fabular City") }
	let!(:other_city) { Location.new(name: "Other City") }

	describe "for non signed-in users" do
		before { visit events_path }
	    it { should have_content('Login') }
	end

	describe "for signed-in users" do

		before do
			user.save
			fabular_city.save
			other_city.save
			sign_in user
		end

		describe "should return to list without character set" do
			before { visit events_path }
		    it { should have_content("Hello #{user.email}") }
		end

		describe "for signed-in users, and with character set" do

			let!(:magnus) { FactoryGirl.create(:character, location_id: fabular_city.id, user: user) }
			let!(:ella) { FactoryGirl.create(:character, name: "Ella", gender: "K", location_id: fabular_city.id, user: user) }
			let!(:sid) { FactoryGirl.create(:character, name: "Sid", location_id: other_city.id, user: user) }
			
			describe "should have events for character" do
				before do
					visit list_path
					click_link "Magnus"
				end
				it { should have_content("Zdarzenia dla: Magnus") }
				it { should have_content("Miejsce: Fabular City") }
				it { should have_link("Magnus") }
				it { should have_link("nieznana kobieta") }
				it { should_not have_link("Sid") }
			end
		    
		end

	end

end