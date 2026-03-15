# frozen_string_literal: true

require_relative 'seeds/project_types'
require_relative 'seeds/item_types'
require_relative 'seeds/settings'
require_relative 'seeds/locations'
require_relative 'seeds/resources'
require_relative 'seeds/recipes'

User.create!(email: 'm@m.eu', password: 'fabular', password_confirmation: 'fabular')
