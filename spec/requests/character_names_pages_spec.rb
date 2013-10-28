#encoding = utf-8
require 'spec_helper'

#tests for changing (remembering) characters names

describe "CharacterNamesPages" do

  describe "should get page with form when clicking character name on events page" do
	
	let!(:user) { FactoryGirl.create(:user) }
	let!(:fabular_city) { Location.new(name: "Fabular City") }

    before do
    	user.save
    	fabular_city.save
    	sign_in user
    end

    subject { page }

    describe "should have links" do
    	# 2 characters in the same location
		let!(:magnus) { FactoryGirl.create(:character, location_id: fabular_city.id, user: user) }
		let!(:ella) { FactoryGirl.create(:character, name: "Ella", gender: "K", location_id: fabular_city.id, user: user) }

		before do	
			magnus.save
			ella.save
			choose_character magnus
    		visit events_path
    	end

        describe "when character is not yet remembered" do

            it { should have_link("nieznana kobieta", :href => character_name_url(ella.id)) }

            describe "after name click" do
                before { click_link "nieznana kobieta" }
                it { should have_content("Obecna nazwa postaci: nieznana kobieta") }

                it "should save new name" do
                    fill_in "char_name_name", with: "Ella"
                    expect { click_button "Utwórz" }.to change(CharName, :count).by(1)
                end

            end

        end

	    describe "when character is already remembered" do

	    	let!(:name_for_ella) { CharName.new(
	    		character_id: magnus.id, 
	    		named_id: ella.id,
	    		name: "Ella"
    		) }

    		before do 
    			name_for_ella.save
    			visit events_path
    		end

    		it { should have_link("Ella") }

    		describe "after name click" do
    			before { click_link "Ella" }
    			it { should have_content("Obecna nazwa postaci: Ella") }

                it "should update name" do
                    fill_in "char_name_name", with: "Mrs. Ella"
                    expect { click_button "Utwórz" }.not_to change(CharName, :count)
                    expect(name_for_ella.reload.name).to eq "Mrs. Ella"
                end

    		end

	    end
	end

  end
end
