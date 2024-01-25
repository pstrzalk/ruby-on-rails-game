require 'test_helper'

class StoryIntegrationTest < ActionDispatch::IntegrationTest
  test 'can see the story page' do
    get '/story'

    assert_select 'p', 'Once upon a time, in a land far away, lived a Prince called David and a Prince called Ruby'
    assert_select 'a', 'Hurry! Help the Prince rescue the Princess!'
  end
end
