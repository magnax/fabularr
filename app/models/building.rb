# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id                 :integer          not null, primary key
#  coords             :point
#  max_capacity       :integer
#  max_characters     :integer
#  name               :string
#  created_at         :datetime
#  updated_at         :datetime
#  location_class_id  :bigint
#  location_type_id   :integer
#  parent_location_id :integer
#
# Indexes
#
#  index_locations_on_location_class_id  (location_class_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_class_id => location_classes.id)
#
class Building < Location
  default_scope(
    lambda {
      joins(:location_class)
      .where(location_class: { key: LocationClass::BUILDING })
    }
  )
end
