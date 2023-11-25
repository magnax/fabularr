# frozen_string_literal: true

FactoryBot.define do
  factory :char_name do
    character
    named
    name { 'Magnus' }
    description { 'Magnus description' }
  end
end  
