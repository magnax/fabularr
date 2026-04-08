# frozen_string_literal: true

# == Schema Information
#
# Table name: settings
#
#  id    :bigint           not null, primary key
#  key   :string
#  value :string
#
class Setting < ApplicationRecord
  def self.setup(key, value = '1')
    Setting.where(key: key).first_or_create.update(value: value)
  end
end
