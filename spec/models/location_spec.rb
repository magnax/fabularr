# frozen_string_literal: true

require 'spec_helper'

describe Location do
  subject { @location }

  before { @location = create(:location) }

  it { is_expected.to respond_to(:locationtype_id) }

  it { is_expected.to respond_to(:characters) }

  # characters in location may see each other (only if they are in exact the same location)
  # or may only hear each other (and see some types of events), when they are in parent or
  # child locations which meets some conditions
  it { is_expected.to respond_to(:visible_characters) }
  it { is_expected.to respond_to(:hearable_characters) }

  it { is_expected.to be_valid }
end
