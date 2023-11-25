# frozen_string_literal: true

require 'spec_helper'

describe User do
  before do 
  	@user = create(:user)
  end  	

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  it { should respond_to(:characters) }

  it { should be_valid }

  it do
    expect(subject.remember_token).to_not be_blank
  end

  describe 'when email is not present' do
    before { @user.email = '' }
    it { should_not be_valid }
  end

  describe 'when email format is invalid' do
    it 'should be invalid' do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe 'when email format is valid' do
    it 'should be valid' do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  it 'is invalid when email address is already taken' do
    expect(build(:user, email: @user.email)).to_not be_valid
  end

  describe 'email address with mixed case' do
    let(:mixed_case_email) { 'Foo@ExAMPle.CoM' }

    it 'should be saved as all lower-case' do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end
  
  it 'is invalid when password is not present' do
    expect(build(:user, password: '')).to_not be_valid
  end

  it 'is invalid when password does not match confirmation' do
    expect(build(:user, password_confirmation: 'mismatch')).to_not be_valid
  end

  it 'is invalid with a password that is too short' do
    expect(build(:user, password: 'aaaaa', password_confirmation: 'aaaaa')).to_not be_valid
  end

  describe 'return value of authenticate method' do
    let(:found_user) { User.find_by(email: @user.email) }

    describe 'with valid password' do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe 'with invalid password' do
      let(:user_for_invalid_password) { found_user.authenticate('invalid') }

      it { should_not eq user_for_invalid_password }
      
      it 'is false' do
        expect(user_for_invalid_password).to eq false
      end
    end
  end
end
