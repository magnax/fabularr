# frozen_string_literal: true

User.create!(email: 'm@m.eu', password: 'fabular',
             password_confirmation: 'fabular', god: true)
User.create!(email: 'a@a.eu', password: 'fabular',
             password_confirmation: 'fabular')

require_relative 'seeds/project_types'
require_relative 'seeds/item_types'
require_relative 'seeds/settings'
require_relative 'seeds/locations'
require_relative 'seeds/skills'
require_relative 'seeds/raw_resources'
require_relative 'seeds/recipes'
