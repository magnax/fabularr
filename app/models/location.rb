class Location < ActiveRecord::Base
has_many :characters

def visible_characters
	characters
end

def hearable_characters
	# not final implementation!
	characters
end

end
