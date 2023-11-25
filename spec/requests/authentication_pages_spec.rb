require 'spec_helper'

describe "Authentication" do
  $login_title = 'Fabular login'
  subject { page }

  describe "login page" do
    before { visit login_path }

    it { should have_content($login_title) }

    describe "with invalid information" do
      before { click_button "Login" }

      it { should have_content('Fabular login') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid username or password') }
    end

    describe "with valid information" do
      
      let(:user) { create(:user) }

      before do
        fill_in "E-mail",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Login"
      end

      it { should have_content("Hello #{user.email}") }
      it { should have_content("You don't have any characters") }
      it { should have_link('Profile',     href: list_path) }
      it { should have_link('Logout',    href: logout_path) }
      it { should_not have_link('Login', href: login_path) }

      describe "followed by signout" do
        before { click_link "Logout" }
        it { should have_link('Login') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { create(:user) }

      describe "in the Users controller" do

        describe "visiting the characters page" do
          before { visit user_path(user) }
          it { should have_content($login_title) }
        end

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_content($login_title) }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(login_path) }
        end
      end
    end
  end
end
