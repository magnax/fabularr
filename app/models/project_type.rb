# frozen_string_literal: true

# == Schema Information
#
# Table name: project_types
#
#  id         :bigint           not null, primary key
#  base_speed :integer
#  fixed      :boolean
#  key        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ProjectType < ApplicationRecord
end
