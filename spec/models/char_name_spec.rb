# frozen_string_literal: true

require 'spec_helper'

describe CharName do
  subject { name }

  let(:name) { create(:char_name) }

  it { is_expected.to respond_to(:character) }
  it { is_expected.to respond_to(:named) }

  it { is_expected.to be_valid }

  describe 'when character_id is not present' do
    before { name.character_id = nil }

    it { is_expected.not_to be_valid }
  end

  describe 'when named_id is not present' do
    before { name.named_id = nil }

    it { is_expected.not_to be_valid }
  end

  describe 'when name is not present' do
    before { name.name = '' }

    it { is_expected.not_to be_valid }
  end
end
