require 'spec_helper'

describe Location do
  before { @location = Location.new(
  	locationtype_id: 1,
  	locationclass_id: 1,
  	name: "Fabular City",
  	parent_location_id: nil
  )}

  subject { @location }

  it { should respond_to(:locationtype_id)}

  it { should respond_to(:characters)}  

  #characters in location may seen each other (only if they are in exact the same location)
  # or may only hear each other (and see some types of events), when they are in parent or
  # child locations which meets some conditions
  it { should respond_to(:visible_characters)}
  it { should respond_to(:hearable_characters)}

  it { should be_valid }

end
