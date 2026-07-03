# frozen_string_literal: true

pt_created = 0
pt_updated = 0

Definitions::ProjectTypes::CONFIG.each do |c|
  pt = ProjectType.find_by(key: c[:key])

  attrs = {
    base_speed: c[:base_speed] || 0,
    fixed: c[:fixed] || false
  }

  if pt
    pt.update!(attrs)
    pt_updated += 1
  else
    ProjectType.create(attrs.merge(key: c[:key]))
    pt_created += 1
  end
end

Log.say "Project types: created #{pt_created}, updated #{pt_updated}"
