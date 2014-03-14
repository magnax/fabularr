require 'spec_helper'

describe "Static Pages" do
  describe "Home page" do
    it "should have the content 'Fabularr' and proper title" do
      visit root_path
      expect(page).to have_content('Fabularr')
      expect(page).to have_title('Fabularr')
    end
  end
end
