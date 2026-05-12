# frozen_string_literal: true

class ActiveSupport::TestCase
  def mock_maps
    Maps.expects(:location_type).with(anything, anything)
        .times(0..1).returns(create(:location_type))
  end
end
