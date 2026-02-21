# frozen_string_literal: true

require 'spec_helper'

describe User do
  subject { @user }

  before do
    @user = create(:user)
  end

  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password_digest) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to respond_to(:remember_token) }
  it { is_expected.to respond_to(:authenticate) }

  it { is_expected.to respond_to(:characters) }

  it { is_expected.to be_valid }

  it do
    expect(subject.remember_token).not_to be_blank
  end

  describe 'when email is not present' do
    before { @user.email = '' }

    it { is_expected.not_to be_valid }
  end

  describe 'when email format is invalid' do
    it 'is invalid' do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe 'when email format is valid' do
    it 'is valid' do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  it 'is invalid when email address is already taken' do
    expect(build(:user, email: @user.email)).not_to be_valid
  end

  describe 'email address with mixed case' do
    let(:mixed_case_email) { 'Foo@ExAMPle.CoM' }

    it 'is saved as all lower-case' do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  it 'is invalid when password is not present' do
    expect(build(:user, password: '')).not_to be_valid
  end

  it 'is invalid when password does not match confirmation' do
    expect(build(:user, password_confirmation: 'mismatch')).not_to be_valid
  end

  it 'is invalid with a password that is too short' do
    expect(build(:user, password: 'aaaaa', password_confirmation: 'aaaaa')).not_to be_valid
  end

  describe 'return value of authenticate method' do
    let(:found_user) { described_class.find_by(email: @user.email) }

    describe 'with valid password' do
      it { is_expected.to eq found_user.authenticate(@user.password) }
    end

    describe 'with invalid password' do
      let(:user_for_invalid_password) { found_user.authenticate('invalid') }

      it { is_expected.not_to eq user_for_invalid_password }

      it 'is false' do
        expect(user_for_invalid_password).to be false
      end
    end
  end
end
