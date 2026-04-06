# frozen_string_literal: true

# == Schema Information
#
# Table name: characters
#
#  id                :integer          not null, primary key
#  coords            :point
#  damage            :float            default(0.0)
#  gender            :string
#  hunger            :float            default(0.0)
#  name              :string
#  tiredness         :float            default(0.0)
#  created_at        :datetime
#  updated_at        :datetime
#  location_id       :integer
#  spawn_location_id :integer
#  user_id           :integer
#
require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
  test 'model fields and methods' do
    character = create(:character)

    assert_respond_to character, :name
    assert_respond_to character, :gender
    assert_respond_to character, :user_id
    assert_respond_to character, :location_id
    assert_respond_to character, :spawn_location_id
    assert_respond_to character, :user
    assert_respond_to character, :char_names
    assert_respond_to character, :default_name
    assert_respond_to character, :name_for
    assert_respond_to character, :location
    assert_respond_to character, :spawn_location
    assert_respond_to character, :coords

    assert_respond_to character, :x
    assert_respond_to character, :y
  end

  test 'valid character' do
    character = build(:character, user: create(:user), name: 'Magnus',
                                  gender: 'M', location: create(:location),
                                  spawn_location: create(:location))

    assert character.valid?
  end

  test 'invalid without user_id' do
    character = build(:character, user_id: nil)

    assert_not character.valid?
    assert_includes character.errors[:user_id], "can't be blank"
  end

  test 'invalid without name' do
    character = build(:character, name: '')

    assert_not character.valid?
    assert_includes character.errors[:name], 'should be given'
  end

  test 'invalid without gender' do
    character = build(:character, gender: '')

    assert_not character.valid?
    assert_includes character.errors[:gender], 'should be given'
  end

  test 'invalid without location' do
    character = build(:character, location_id: nil)

    assert_not character.valid?
    assert_includes character.errors[:location_id], "can't be blank"
  end

  test 'invalid without spawn location' do
    character = build(:character, spawn_location_id: nil)

    assert_not character.valid?
    assert_includes character.errors[:spawn_location_id], "can't be blank"
  end

  test 'invalid with wrong gender' do
    character = build(:character, gender: 'W')

    assert_not character.valid?
    assert_includes character.errors[:gender], 'invalid'

    character.gender = 'woman'
    assert_not character.valid?
    assert_includes character.errors[:gender], 'invalid'
  end

  test 'save gender as uppercase' do
    character = create(:character, gender: 'm')

    assert_equal 'M', character.gender
  end

  test 'respond to default name' do
    character = create(:character, gender: 'K')

    assert_equal 'unknown woman', character.default_name

    character.update(gender: 'M')
    assert_equal 'unknown man', character.default_name
  end

  test 'carrying_weight' do
    character = create(:character)
    iron = create(:resource, key: 'iron')
    sand = create(:resource, key: 'sand')
    create(:inventory_object, character: character, subject: iron, amount: 200)
    create(:inventory_object, character: character, subject: sand, amount: 300)

    assert_equal 500, character.carrying_weight
  end

  test 'read coordinates' do
    character = build(:character, coords: '22.3,44.5')

    assert_equal 22.3, character.x
    assert_equal 44.5, character.y
  end

  test 'project info' do
    character = create(:character)
    project = create(:project, :build, location: character.location, duration: 100, elapsed: 43)
    create(:worker, character: character, project: project, left_at: nil)

    assert_equal 'Building', character.project_info[:name]
    assert_equal 43, character.project_info[:percent]
  end
end
