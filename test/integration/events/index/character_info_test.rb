# frozen_string_literal: true

require 'test_helper'

class EventsIndexCharacterInfoTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user, email: 'user@me.com')
  end

  test 'show project in character info' do
    fabular_city = create(:location)
    character = create(:character, name: 'Magnus', location: fabular_city, user: @user)
    recipe = create(:recipe)
    project = create(:project, location: fabular_city, recipe: recipe, elapsed: 300, duration: 600)

    create(:worker, character: character, project: project)

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_content 'Project:'
    assert_content 'Building: stone knife 50.0%'
  end

  test 'show project in character info - join project links' do
    fabular_city = create(:location)
    create(:character, name: 'Magnus', location: fabular_city, user: @user)
    recipe_hand = create(:recipe)
    recipe_auto = create(:recipe, run_type: Project::AUTOMATIC)
    project_hand = create(:project, location: fabular_city, recipe: recipe_hand,
                                    elapsed: 300, duration: 600, ready: true)
    project_auto = create(:project, location: fabular_city, recipe: recipe_auto,
                                    elapsed: 300, duration: 600, ready: true)

    sign_in
    click_link 'Magnus'

    assert_equal 200, page.status_code

    assert_link nil, title: 'Join project',
                     href: "#{host}/en/projects/#{project_hand.id}/join"
    assert_no_link nil, title: 'Join project',
                        href: "#{host}/en/projects/#{project_auto.id}/join"
  end
end
