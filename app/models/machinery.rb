# frozen_string_literal: true

# == Schema Information
#
# Table name: machineries
#
#  id         :bigint           not null, primary key
#  key        :string
#  placement  :string           is an Array
#  portable   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Machinery < ApplicationRecord
end
