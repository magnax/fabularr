# frozen_string_literal: true

require 'test_helper'

class SeedsRecipesTest < ActiveSupport::TestCase
  test 'works' do
    assert_difference -> { Recipe.count } => 6,
                      -> { RecipeInstruction.count } => 9 do
      require_relative '../../db/seeds/recipes'
    end
  end
end
