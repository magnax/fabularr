# frozen_string_literal: true

Definitions::ProjectTypes::CONFIG.each do |c|
  ProjectType.where(key: c[:key])
             .first_or_create(base_speed: c[:base_speed], fixed: c[:fixed])
end
