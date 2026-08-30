# frozen_string_literal: true

require 'test_helper'

class InventoryObjectsConsumeServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(params)
    InventoryObjects::ConsumeService.call(@character, params)
  end

  test '#post raise exception when invalid resource' do
    params = {
      subject_id: 0,
      subject_type: 'Resource',
      amount: 250
    }

    assert_raises InventoryObjects::ConsumeService::InvalidResourceError do
      call_service(params)
    end
  end
end
