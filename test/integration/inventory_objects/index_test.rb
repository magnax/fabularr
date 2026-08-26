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

  test 'edible resources have proper links' do
    grilled_meat = create(:resource, :food, key: 'grilled_meat')
    inv_meat = create(:inventory_object, character: @character,
                                         subject: grilled_meat, amount: 100)

    visit 'en/inventory_objects'

    assert_content '100 grams grilled meat'
    assert_link 'Eat', href: "#{host}/en/inventory_objects/#{inv_meat.id}/eat"
  end

  test 'healing resources have proper links' do
    mushrooms = create(:resource, :medicine, key: 'mushrooms')
    inv_mushrooms = create(:inventory_object, character: @character,
                                              subject: mushrooms, amount: 100)

    visit 'en/inventory_objects'

    assert_content '100 grams mushrooms'
    assert_link 'Eat', href: "#{host}/en/inventory_objects/#{inv_mushrooms.id}/eat"
  end
end
