require 'spec_helper'

describe "Character creation" do

  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:location) { FactoryGirl.create(:location) }

  before { sign_in user }

  describe "user can create first character" do
    before do
      visit list_path
      click_link "Create new character"
    end

    it { should have_content('New character') }

    describe "create character" do
      before do
        fill_in "Name", with: "Magnus"
        select('Female', :from => 'Gender')
      end

      it "should create character" do
        expect { click_on 'Create character' }.to change(Character, :count).by(1)
        expect(page).to have_selector('div.alert-success', :text => 'New character successfully created')
      end
    end
  end

  describe "user cannot create more than 5 characters" do
    before { FactoryGirl.create_list(:character, 15, { user: user }) }

    describe "from list of characters" do
      before { visit list_path }

      it { should have_content('You cannot create more characters') }
    end

    describe "from direct link" do
      before { visit new_character_path }

      it "should redirect to list" do
        expect(current_path).to eq list_path
        expect(page).to have_selector('div.alert-error', :text => "You cannot create more than 15 characters")
      end
    end
  end
end
