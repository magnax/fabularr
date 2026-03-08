# frozen_string_literal: true

Setting.where(key: 'projects').first_or_create
