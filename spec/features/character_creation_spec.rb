# frozen_string_literal: true

require 'spec_helper'

describe 'Character creation' do
  subject { page }

  let!(:user) { create(:user) }

  before do
    create(:location)
    sign_in user
  end

  describe 'user can create first character' do
    before do
      visit list_path
      click_link 'Create new character'
    end

    it { is_expected.to have_content('New character') }

    describe 'create character' do
      before do
        fill_in 'Name', with: 'Magnus'
        select('Female', from: 'Gender')
      end

      it 'creates character' do
        expect { click_on 'Create character' }.to change(Character, :count).by(1)
        expect(page).to have_selector('div.alert-success', text: 'New character successfully created')
      end
    end
  end

  describe 'user cannot create more than 15 characters' do
    before { create_list(:character, 15, { user: user }) }

    describe 'from list of characters' do
      before { visit list_path }

      it { is_expected.to have_content('You cannot create more characters') }
    end

    describe 'from direct link' do
      before { visit new_character_path }

      it 'redirects to list' do
        expect(page).to have_current_path list_path, ignore_query: true
        expect(page).to have_selector('div.alert-error', text: 'You cannot create more than 15 characters')
      end
    end
  end
end
