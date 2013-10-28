require 'spec_helper'

describe CharName do
  
  before do
  	@name = CharName.new(
  		character_id: 1,
  		named_id: 2,
  		name: "Magnus",
  		description: "Magnus description"
	)
  end

  subject { @name }

  	it { should respond_to(:character) }
  	it { should respond_to(:named) }

  	it { should be_valid }

  	describe "when character_id is not present" do
		before { @name.character_id = nil }
		it { should_not be_valid }
	end

	describe "when named_id is not present" do
		before { @name.named_id = nil }
		it { should_not be_valid }
	end

	describe "when name is not present" do
		before { @name.name = nil }
		it { should_not be_valid }
	end

end
