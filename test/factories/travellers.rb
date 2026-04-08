# frozen_string_literal: true

# == Schema Information
#
# Table name: travellers
#
#  id                :bigint           not null, primary key
#  checked_at        :datetime
#  direction         :float
#  speed             :float            default(100.0)
#  status            :boolean          default(TRUE)
#  subject_type      :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  end_location_id   :bigint
#  start_location_id :bigint
#  subject_id        :bigint
#
# Indexes
#
#  index_travellers_on_end_location_id    (end_location_id)
#  index_travellers_on_start_location_id  (start_location_id)
#  index_travellers_on_subject            (subject_type,subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (end_location_id => locations.id)
#  fk_rails_...  (start_location_id => locations.id)
#
FactoryBot.define do
  factory :traveller do
    start_location { FactoryBot.create(:location) }
  end
end
