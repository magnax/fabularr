# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user)

    sign_in
    click_link 'Magnus'
  end

  test 'resources and items are visible' do
    iron = create(:resource, key: 'iron')
    stone_knife = create(:item_type, key: 'stone_knife', weight: 120)
    knife = create(:item, item_type: stone_knife, placeable: @character)
    inv_iron = create(:inventory_object, character: @character, subject: iron,
                                         amount: 200)
    inv_knife = create(:inventory_object, character: @character, subject: knife,
                                          unit: nil)
    visit 'en/inventory_objects'

    assert_equal 200, page.status_code
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

    assert_equal 200, page.status_code
    assert_content '100 grams grilled meat'
    assert_link 'Eat', href: "#{host}/en/inventory_objects/#{inv_meat.id}/eat"
  end

  test 'healing resources have proper links' do
    mushrooms = create(:resource, :medicine, key: 'mushrooms')
    inv_mushrooms = create(:inventory_object, character: @character,
                                              subject: mushrooms, amount: 100)

    visit 'en/inventory_objects'

    assert_equal 200, page.status_code
    assert_content '100 grams mushrooms'
    assert_link 'Eat', href: "#{host}/en/inventory_objects/#{inv_mushrooms.id}/eat"
  end

  test 'notes are visible' do
    note = create(:note, title: 'First Note', character: @character)
    note_2 = create(:note, editable: false)
    create(:inventory_object, character: @character, subject: note)
    create(:inventory_object, character: @character, subject: note_2)

    visit 'en/inventory_objects'

    assert_equal 200, page.status_code

    assert_content 'note - "First Note"'
    assert_link nil, href: "#{host}/en/notes/#{note.id}/copy", title: 'Copy this note'

    # edit note link - only for editable note
    assert_link nil, href: "#{host}/en/notes/#{note.id}/edit", title: 'Edit this note'
    assert_no_link nil, href: "#{host}/en/notes/#{note_2.id}/edit"

    # view note link
    assert_link nil, href: "#{host}/en/notes/#{note.id}", title: 'Read this note'
    assert_link nil, href: "#{host}/en/notes/#{note_2.id}", title: 'Read this note'

    # point note link
    assert_link nil, href: "#{host}/en/point/note/#{note.id}", title: 'Point at this note'
  end
end
