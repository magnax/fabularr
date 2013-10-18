require 'spec_helper'

describe "Events" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }

	describe "for non-signed-in users" do
		before { visit events_path }
	    it { should have_content('Login') }
	end

	describe "for signed-in users, but without character set" do
		before do 
			sign_in user
			visit events_path
		end
	    it { should have_content("Hello #{user.email}") }
	end

	describe "for signed-in users, and with character set" do
		before { user.save } 
		let!(:character) { FactoryGirl.create(:character, user: user) }
		
		describe "should have events for character" do
			before do
				sign_in user
				visit list_path
				click_link "Magnus"
			end
			it { should have_content("Zdarzenia dla: Magnus") }
		end
	    
	end

end