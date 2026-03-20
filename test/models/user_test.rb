# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'invalid without email' do
    user = build(:user, email: '')

    assert_not user.valid?
  end

  test 'invalid with invalid email format' do
    user = create(:user)

    addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                   # foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    addresses.each do |invalid_address|
      user.email = invalid_address

      assert_not user.valid?
      assert_equal ['is invalid'], user.errors[:email]
    end
  end

  test 'valid email addresses' do
    user = create(:user)

    addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
    addresses.each do |valid_address|
      user.email = valid_address

      assert user.valid?
    end
  end

  test 'email is already taken' do
    user = create(:user, email: 'm@m.eu')

    invalid_user = build(:user, email: user.email)
    assert_not invalid_user.valid?
  end

  test 'save email as lowercase' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    user = create(:user, email: mixed_case_email)

    assert_equal mixed_case_email.downcase, user.email
  end

  test 'invalid without password' do
    user = build(:user, password: '')

    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test 'invalid with too short password' do
    user = build(:user, password: 'aaa')

    assert_not user.valid?
    assert_includes user.errors[:password], 'is too short (minimum is 6 characters)'
  end

  test 'when password confirmation does not match' do
    user = build(:user, password: 'abc123', password_confirmation: '321cba')

    assert_not user.valid?
    assert_includes user.errors[:password_confirmation], "doesn't match Password"
  end

  test 'authenticate with valid password' do
    user = create(:user, email: 'm@m.eu')

    auth_user = User.find_by(email: 'm@m.eu')
    assert auth_user.authenticate(user.password)
  end

  test 'authenticate with invalid password' do
    create(:user, email: 'm@m.eu')

    auth_user = User.find_by(email: 'm@m.eu')
    assert_not auth_user.authenticate('invalid password')
  end

  test 'fields' do
    user = create(:user)

    assert_respond_to user, :email
    assert_respond_to user, :password_digest
    assert_respond_to user, :password
    assert_respond_to user, :password_confirmation
    assert_respond_to user, :remember_token
  end

  test 'methods' do
    user = create(:user)

    assert_respond_to user, :authenticate
    assert_respond_to user, :characters
  end
end
