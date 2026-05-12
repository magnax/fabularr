# frozen_string_literal: true

class ActiveSupport::TestCase
  def mock_maps(times = 1)
    Maps.expects(:location_type).with(anything, anything)
        .times(0..times).returns(create(:location_type))
  end
end
