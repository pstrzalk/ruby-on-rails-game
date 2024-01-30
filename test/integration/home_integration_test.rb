# frozen_string_literal: true

require 'test_helper'

class HomeIntegrationTest < ActionDispatch::IntegrationTest
  test 'can see the home page' do
    get '/'

    assert_select 'body.main_screen'
  end
end
