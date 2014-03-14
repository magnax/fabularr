class Location < ActiveRecord::Base
has_many :characters

scope :random, -> { order("RAND()").limit(1) }

def visible_characters
	characters
end

def hearable_characters
	# not final implementation!
	characters
end

end
