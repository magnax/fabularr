# frozen_string_literal: true

require 'test_helper'

class NotesUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user, email: 'user@me.com')
    @character = create(:character, user: @user, name: 'Magnus')
  end

  test 'fill the form and update a note' do
    note = create(:note, title: 'Title', body: 'Body')
    create(:inventory_object, character: @character, subject: note)

    sign_in(@user)
    click_on 'Magnus'

    visit "en/notes/#{note.id}/edit"

    assert_no_difference -> { Note.count } do
      fill_in 'Title', with: 'New title'
      fill_in 'note_body', with: 'New body'
      click_on 'Store'
    end

    assert_equal 200, page.status_code

    assert_equal 'New title', note.reload.title
    assert_equal 'New body', note.body

    assert_content 'note - "New title"'
  end

  test 'update a note' do
    note = create(:note, title: 'Title', body: 'Body')
    create(:inventory_object, character: @character, subject: note)

    login(@user, @character)

    params = {
      note: {
        id: note.id,
        title: 'Edited title',
        body: 'Edited body'
      }
    }

    put "/notes/#{note.id}", params: params

    assert_equal 'Edited title', note.reload.title
    assert_equal 'Edited body', note.body

    assert_redirected_to inventory_objects_path
  end

  test 'update a note - strip html from title' do
    note = create(:note, title: 'Title')
    create(:inventory_object, character: @character, subject: note)

    login(@user, @character)

    params = {
      note: {
        id: note.id,
        title: '<b>Edited title</b>'
      }
    }

    put "/notes/#{note.id}", params: params

    assert_equal 'Edited title', note.reload.title

    assert_redirected_to inventory_objects_path
  end

  test 'update a note - strip html (script) from body' do
    note = create(:note, title: 'Title')
    create(:inventory_object, character: @character, subject: note)

    login(@user, @character)

    params = {
      note: {
        id: note.id,
        body: '<b>Edited</b><script>console.log("test");</script> <i>title</i>'
      }
    }

    put "/notes/#{note.id}", params: params

    assert_equal '<b>Edited</b> <i>title</i>', note.reload.body
  end
end
