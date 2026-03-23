# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    # fabular_city = create(:location, name: 'Fabular City')
    @character = create(:character, name: 'Magnus', user: @user)
    sign_in
    click_link 'Magnus'
  end

  def sign_in
    visit new_session_url
    fill_in 'E-mail', with: @user.email
    fill_in 'Password', with: @user.password

    click_on 'Login'
  end

  test 'resources and items are visible' do
    iron = create(:resource, key: 'iron')
    stone_knife = create(:item_type, key: 'stone_knife', weight: 120)
    knife = create(:item, item_type: stone_knife, placeable: @character)
    inv_iron = create(:inventory_object, character: @character, subject: iron, amount: 200)
    inv_knife = create(:inventory_object, character: @character, subject: knife, unit: nil)
    visit 'en/inventory_objects'

    assert_content 'Inventory'
    assert_content '200 grams iron'
    assert_content 'brand new stone knife'
    assert_link 'Drop', href: "#{host}/en/inventory_objects/#{inv_iron.id}/drop"
    assert_link 'Drop', href: "#{host}/en/inventory_objects/#{inv_knife.id}/drop_item"
  end
end
