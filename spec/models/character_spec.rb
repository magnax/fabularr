require 'spec_helper'

describe Character do
  
  	let(:user) { FactoryGirl.create(:user) }
	before do
		@character = user.characters.build(name: "Magnus", gender: "M", location_id: 1, spawn_location_id: 1)
	end

	subject { @character }

	it { should respond_to(:name) }
	it { should respond_to(:gender) }
	it { should respond_to(:user_id) }
	it { should respond_to(:location_id) }
	it { should respond_to(:spawn_location_id) }
	it { should respond_to(:user) }
    its(:user) { should eq user }

	it { should be_valid }

	describe "when user_id is not present" do
		before { @character.user_id = nil }
		it { should_not be_valid }
	end

	describe "when gender is not present" do
		before { @character.gender = nil }
		it { should_not be_valid }
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
			@valid_genders = ['K', 'M']
		end
		it { should_not be_valid }
	end
	
	describe "when gender is not K/M" do
		before do
			@character.gender = 'kobieta'
			@valid_genders = ['K', 'M']
		end
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

end
