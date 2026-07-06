# frozen_string_literal: true

# == Schema Information
#
# Table name: project_descriptions
#
#  id               :bigint           not null, primary key
#  amount           :float
#  amount_needed    :float
#  description_type :string
#  metadata         :jsonb
#  subject_type     :string
#  unit             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  project_id       :bigint
#  subject_id       :integer
#
# Indexes
#
#  index_project_descriptions_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
FactoryBot.define do
  factory :project_description do
    subject_id { 1 }
    subject_type { 'Resource' }
    unit { 'grams' }
    amount { 1.5 }
    project

    %i[location_resource machine repeat resource_in
       resource_out road settings].each do |key|
      trait key do
        description_type { ProjectDescription.const_get(key.to_s.upcase) }
      end
    end
  end
end
