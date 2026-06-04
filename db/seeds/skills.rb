# frozen_string_literal: true

Skill::SKILLS.each { |key| Skill.where(key: key).first_or_create }
