# frozen_string_literal: true

require 'spec_helper'

describe 'User pages', type: :feature do

  subject { page }

  describe 'signup page' do
    before { visit register_path }

    it { should have_content('Register') }

  end

  describe 'signup' do

    before { visit register_path }

    let(:submit) { 'Create my account' }

    describe 'with invalid information' do
      it 'should not create a user' do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe 'with valid information' do
      before do
        fill_in 'E-mail', with: 'user@example.com'
        fill_in 'Password', with: 'foobar'
        fill_in 'Confirmation', with: 'foobar'
      end

      it 'should create a user' do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end
