# frozen_string_literal: true

require 'spec_helper'

describe StaticPagesController, type: :feature do
  context 'Home page' do
    it 'should have proper content and proper title' do
      visit root_path
      expect(page).to have_content('Fabularr')
      expect(page).to have_title('Fabularr')
    end
  end
end
