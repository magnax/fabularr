#encoding = utf-8
require 'spec_helper'

describe Character do
  
	let(:user) { FactoryGirl.create(:user) }
	before { @character = FactoryGirl.create(:character, user: user) }

	subject { @character }

	it { should respond_to(:name) }
	it { should respond_to(:gender) }
	it { should respond_to(:user_id) }
	it { should respond_to(:location_id) }
	it { should respond_to(:spawn_location_id) }
	it { should respond_to(:user) }

	#char_names is a collection of characters remembered by this character
	it { should respond_to(:char_names) }

	it { should respond_to(:default_name) }
	it { should respond_to(:name_for) }

	#location & spawn location are Location models related to Character
	it { should respond_to(:location) }
	it { should respond_to(:spawn_location) }

	it do
  	expect(subject.user).to eq user
  end

	it { should be_valid }

	it "is invalid when user_id is not present" do
		expect(FactoryGirl.build(:character, user: nil)).to_not be_valid
	end

  it "is invalid when name is not present" do
    expect(FactoryGirl.build(:character, name: '')).to_not be_valid
  end

	it "is invalid when gender is not present" do
    expect(FactoryGirl.build(:character, gender: nil)).to_not be_valid
	end

	describe "when gender is not present" do
		before do
			@character.gender = nil
		end
		it { should_not be_valid }
	end

	describe "when gender is not K/M" do
		before do
			@character.gender = 'W'
		end
		it { should_not be_valid }
	end
	
	describe "when gender is not K/M" do
		before do
			@character.gender = 'kobieta'
		end
		it { should_not be_valid }
	end

	describe "when location_id is nil" do
		before { @character.location_id = nil }
		it { should_not be_valid }
	end

	describe "when spawn location_id is nil" do
		before { @character.spawn_location_id = nil }
		it { should_not be_valid }
	end

	describe "gender with lower case" do
    let(:lower_case_gender) { "k" }

    it "should be saved as uppercase" do
      @character.gender = lower_case_gender
      @character.save
      expect(@character.reload.gender).to eq lower_case_gender.upcase
    end
  end

  describe "should respond with proper default name" do
  	it "is an unknown man" do
  		expect(@character.default_name).to eq "unknown man"
  	end

  	it "is an unknown woman" do
  		@character.gender = 'K'
  		expect(@character.default_name).to eq "unknown woman"
  	end
  end
end
