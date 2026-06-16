# frozen_string_literal: true

Skill::SKILLS.each { |key| Skill.where(key: Skill.const_get(key)).first_or_create }
