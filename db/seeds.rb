# frozen_string_literal: true

User.create!(email: 'm@m.eu', password: 'fabular',
             password_confirmation: 'fabular', god: true)
User.create!(email: 'a@a.eu', password: 'fabular',
             password_confirmation: 'fabular')

Seeds::Animals.call
require_relative 'seeds/project_types'
Seeds::ItemTypes.call
require_relative 'seeds/settings'
Seeds::Skills.call
Seeds::RawResources.call
require_relative 'seeds/materials'
require_relative 'seeds/recipes'
Seeds::Locations.call

# "start" time
GameTime.create!
