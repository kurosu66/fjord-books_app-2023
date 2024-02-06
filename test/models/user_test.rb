# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email should return email when name is blank' do
    user = User.new(email: 'test@test.com', name: '')
    assert_equal 'test@test.com', user.name_or_email
  end

  test '#name_or_email should return name when name is presence' do
    user = User.new(email: 'test@test.com', name: 'alice')
    assert_equal 'alice', user.name_or_email
  end
end
