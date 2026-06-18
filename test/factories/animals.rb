# frozen_string_literal: true

# == Schema Information
#
# Table name: animals
#
#  id         :bigint           not null, primary key
#  agression  :integer
#  attack     :integer
#  health     :integer
#  key        :string
#  mountable  :boolean          default(FALSE)
#  tamable    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :animal do
    key { Faker::Creature::Animal.name }
  end
end
