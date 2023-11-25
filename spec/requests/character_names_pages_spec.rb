#encoding = utf-8
require 'spec_helper'

#tests for changing (remembering) characters names

describe "CharacterNamesPages", type: :feature do

  describe "should get page with form when clicking character name on events page" do
	
  	let!(:user) { create(:user) }
  	let!(:fabular_city) { create(:location) }

    before { sign_in user }

    subject { page }

    describe "should have links" do
  	  # 2 characters in the same location
  	  let!(:magnus) { create(:character, name: "Magnus", location: fabular_city, user: user) }
  	  let!(:ella) { create(:character, name: "Ella", gender: "K", location: fabular_city, user: user) }

  	  before do	
    		choose_character magnus
    		visit events_path
  	  end

      describe "when character is not yet remembered" do

        it { should have_link("unknown woman", :href => character_name_url(ella.id)) }

        describe "after name click" do
          before { click_link "unknown woman" }
        
          it { should have_content("Current name: unknown woman") }

          it "should save new name" do
            fill_in "char_name_name", with: "Ella"
            expect { click_button "Change name" }.to change(CharName, :count).by(1)
          end

          it "should create new default name even if name is not provided" do
            fill_in "char_name_name", with: ""
            expect { click_button "Change name" }.to change(CharName, :count).by(1)
          end
        end
      end

      describe "when character is already remembered" do

    	  let!(:name_for_ella) { create(:char_name, character: magnus, named: ella, name: "Ella") }

		    before { visit events_path }

		    it { should have_link("Ella") }

    		describe "after name click" do
    		  before { click_link "Ella" }
    		  
          it { should have_content("Current name: Ella") }

          describe "actually update the name" do
            before { fill_in "char_name_name", with: "Mrs. Ella" }

            it "changes name with alert" do
              expect { click_button "Change name" }.to_not change(CharName, :count)
              expect(page).to have_link "Mrs. Ella"
              expect(name_for_ella.reload.name).to eq "Mrs. Ella"
              expect(page).to have_selector "div.alert-success", text: "Successfully changed character name"
            end            
          end

          describe "return to default name" do
            before { fill_in "char_name_name", with: "" }
            it "changes name with alert" do
              expect { click_button "Change name" }.to_not change(CharName, :count)
              expect(page).to have_link "unknown woman"
            end
          end
		    end
      end

      describe "when character was remembered and returned to default" do
        let!(:ellas_name) { create(:char_name, character: magnus, named: ella, name: "Ella") }
        before do
          visit character_name_path ella
          fill_in "char_name_name", with: ""
          click_button "Change name"
        end

        it "displays default name" do
          visit character_name_path ella
          expect(page).to have_content "Current name: unknown woman"
        end
      end
	  end
  end
end
