# frozen_string_literal: true

# == Schema Information
#
# Table name: settings
#
#  id    :bigint           not null, primary key
#  key   :string
#  value :string
#
FactoryBot.define do
  factory :setting do
    key { 'jobs' }
    value { '1' }
  end
end
