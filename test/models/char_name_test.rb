# frozen_string_literal: true

# == Schema Information
#
# Table name: char_names
#
#  id           :integer          not null, primary key
#  description  :text
#  name         :string
#  created_at   :datetime
#  updated_at   :datetime
#  character_id :integer
#  named_id     :integer
#
# Indexes
#
#  index_char_names_on_character_id               (character_id)
#  index_char_names_on_character_id_and_named_id  (character_id,named_id) UNIQUE
#  index_char_names_on_named_id                   (named_id)
#
require 'test_helper'

class CharNameTest < ActiveSupport::TestCase
  test 'model fields' do
    charname = build(:char_name)

    assert_respond_to charname, :character
    assert_respond_to charname, :named
    assert_respond_to charname, :name
  end

  test 'valid' do
    charname = build(:char_name, character: create(:character),
                                 named: create(:character),
                                 name: 'Magnus')

    assert charname.valid?
  end

  test 'invalid without character' do
    char_name = build(:char_name, character_id: nil,
                                  named: create(:character),
                                  name: 'Magnus')

    assert_not char_name.valid?
    assert_includes char_name.errors[:character_id], "can't be blank"
  end

  test 'invalid without named character' do
    char_name = build(:char_name, character_id: create(:character),
                                  named: nil,
                                  name: 'Magnus')

    assert_not char_name.valid?
    assert_includes char_name.errors[:named_id], "can't be blank"
  end

  test 'invalid without name' do
    char_name = build(:char_name, character_id: create(:character),
                                  named: create(:character),
                                  name: '')

    assert_not char_name.valid?
    assert_includes char_name.errors[:name], "can't be blank"
  end
end
