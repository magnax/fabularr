# frozen_string_literal: true

# == Schema Information
#
# Table name: item_classes
#
#  id         :bigint           not null, primary key
#  key        :string
#  metadata   :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ItemClass < ApplicationRecord
end
